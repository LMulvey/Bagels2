module EventService
  class Update < ApiBaseService
    def call
      @event = Event.find_by(id: @params[:id])         
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
      is_successful = Event.transaction do
        ticket = Ticket.find_by!(id: @event[:ticket_id])
        ticket.update!(:status => "completed", :completed_at => DateTime.now)
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
  end
end