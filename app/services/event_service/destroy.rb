module EventService
  class Destroy < ApiBaseService
    def call
      @event = Event.find_by(id: @params[:id])
      if @event[:event_type] === "stop"
        handle_stop_event
      else 
        handle_event_destroy
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
        ticket.update!(:status => "active", :completed_at => nil)
        handle_event_destroy
      end
      if is_successful
        response(:ok, [], nil)
      else
        response(:unprocessable_entity, ["Unable to destroy Event. Contact administrator."], nil)
      end
    end

    def handle_event_destroy
      @event.destroy!
    end
  end
end