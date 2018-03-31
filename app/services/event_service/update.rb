module EventService
  class Update < ApiBaseService
    def call
      @event = Event.find_by(id: @params[:id])         
      if @params[:event_type] === "stop"
        handle_stop_event
      else 
        handle_event_update
        @event
      end
    end

    private

    def handle_stop_event
      Event.transaction do
        ticket = Ticket.find_by!(id: @event[:ticket_id])
        ticket.update!(:status => "completed", :completed_at => DateTime.now)
        handle_event_update
      end
      @event
    end

    def handle_event_update
      @event.update!(@params.except(:id))
    end
  end
end