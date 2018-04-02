module EventService
  class Update < ApiBaseService
    def call
      @event = Event.find_by(id: @params[:id])  
      @ticket = Ticket.find_by(id: @event[:ticket_id])  

      if @params[:event_type] === "stop"
        handle_stop_event
      else 
        handle_event_update
        if @event.errors.any?
          response(:unprocessable_entity, @event.errors.full_messages, nil)
        else
          response(:ok, [], @event)
        end
      end
    end

    private

    def handle_stop_event
      start_event = @ticket.events.find_by(event_type: "start")
      return no_stop_without_start if no_start_event(start_event)

      completion_time = handle_completion_time(start_event)

      is_successful = Event.transaction do
        @ticket.update!(:status => "completed", :completed_at => completion_time)
        handle_event_update
      end

      if is_successful
        SendTextMessageJob.perform_later(ticket_complete_message(@event))
        response(:ok, [], @event)
      else
        response(:unprocessable_entity, ["Unable to update Event. Contact administrator."], nil)
      end
    end

    def handle_event_update
      @event.update!(@params.except(:id))
    end

    def no_stop_without_start
      response(:unprocessable_entity, ["Start event required before issuing stop event."], nil)
    end

    def no_start_event(start_event)
      return true if start_event.nil?
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