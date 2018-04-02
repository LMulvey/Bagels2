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
      @event = Event.new(@params)
      is_successful = Event.transaction do
          ticket = Ticket.find_by!(id: @params[:ticket_id])
          ticket.update!(:status => "completed", :completed_at => DateTime.now)
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
  end
end
