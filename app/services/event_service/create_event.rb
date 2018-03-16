module EventService
  class CreateEvent
    def initialize(params = {})
      @event_params = {
        # Set any explicit defaults here
      }.merge(params)
    end

    def call
      return handle_stop_event if @event_params[:event_type] == 'stop'
      Event.create(@event_params)
    end

    private

    def handle_stop_event
      Event.transaction do
        ticket = Ticket.find_by!(id: @event_params[:ticket_id])
        ticket.update!(status: 'completed')
        Event.create!(@event_params)
      end
      return true
    end
  end
end