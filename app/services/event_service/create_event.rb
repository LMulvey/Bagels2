module EventService
  class CreateEvent
    def initialize(params = {})
      @event_params = {
        # Set any explicit defaults here
      }.merge(params)
    end

    def self.call(params = {})
      new(params).call
    end      

    def call
      if @event_params[:event_type] == "stop"
        handle_stop_event
      else 
        Event.create!(@event_params)
      end
    end

    private

    def handle_stop_event
      Event.transaction do
        ticket = Ticket.find_by!(id: @event_params[:ticket_id])
        ticket.update!(:status => "completed")
        event = Event.create!(@event_params)
      end
      return true
    end
  end
end