module EventService
  class Destroy
    def self.call(id)
      @event = Event.find_by(id: id)
      if @event[:event_type] === "stop"
        handle_stop_event
      else 
        handle_event_destroy
      end
    end

    private

    def self.handle_stop_event
      Event.transaction do
        ticket = Ticket.find_by!(id: @event[:ticket_id])
        ticket.update!(:status => "active", :completed_at => nil)
        handle_event_destroy
      end
    end

    def self.handle_event_destroy
      @event.destroy!
    end
  end
end