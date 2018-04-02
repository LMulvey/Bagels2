module EventService
  class Create < ApiBaseService
    def call
      @ticket = Ticket.find_by(id: @params[:ticket_id])
      return response(:unprocessable_entity, ["Ticket does not exist."], nil) if @ticket.nil?
      return response(:unprocessable_entity, ["Ticket is locked. No more events can be added."], nil) if ticket_is_completed

      if @params[:event_type] === "stop"
        handle_stop_event
      elsif measurement_required && measurement_not_present
        response(:unprocessable_entity, ["Measurement details required for PICKUP or DELIVERY."], nil)
      else
        new_event = Event.create!(@params)
        if new_event.errors.any?
          response(:unprocessable_entity, new_event.errors.full_messages, nil)
        else
          response(:ok, [], new_event)
        end
      end
    end

    private

    def handle_stop_event
      start_event = @ticket.events.find_by(event_type: "start")
      return no_stop_without_start if no_start_event(start_event)

      completion_time = handle_completion_time(start_event)

      @event = Event.new(@params)

      is_successful = Event.transaction do
          @ticket.update!(:status => "completed", :completed_at => completion_time)
          @event.save!
        end
      if is_successful
        SendTextMessageJob.perform_later(ticket_complete_message(@event))        
        response(:ok, [], @event)
      else
        response(:unprocessable_entity, [ "Error creating Ticket." ], nil)
      end
    end

    def ticket_is_completed
      @ticket.status === "completed"
    end

    def measurement_required
      @params[:event_type] === "pickup" || @params[:event_type] === "delivery"
    end

    def measurement_not_present
      return true if @params[:measurement].blank?|| @params[:measurement_type].blank?
      false
    end

    def no_stop_without_start
      response(:unprocessable_entity, ["Start event required before issuing stop event."], nil)
    end

    def no_start_event(start_event)
      start_event.nil?
    end

    def handle_completion_time(start_event)
      completion_time = Time.now
      hours_worked = (completion_time - start_event.created_at) / 1.hours

      @params[:measurement] = hours_worked
      @params[:measurement_type] = "hours_worked"
      completion_time
    end
  end
end
