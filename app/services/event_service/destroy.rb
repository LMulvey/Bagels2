module EventService
  # EventService.Destroy: handle destruction of Events
  class Destroy < ApiBaseService
    attr_reader :event

    def initialize(event)
      @event = event
    end

    def self.call(event)
      new(event).call
    end

    def call
      return delete_event_and_update_ticket if @event.event_type == 'stop'
      if @event.destroy!
        true
      else
        false
      end
    end

    private

    def delete_event_and_update_ticket
      Event.transaction do
        @event.ticket.update!(status: 'active', completed_at: nil)
        @event.destroy!
        true
      end
    end
  end
end
