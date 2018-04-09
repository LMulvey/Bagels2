module EventService
  # EventService.Create: handles creation of events
  class Create < ApiBaseService
    attr_reader :event

    def initialize(ticket, params)
      @ticket = ticket
      @params = params

      build
    end

    def self.call(ticket, params)
      new(ticket, params).call
    end

    def call
      return save_stop_event if @params[:event_type] == 'stop'
      if @event.save!
        true
      else
        false
      end
    end

    private

    def build
      @event = Event.new(@params)
    end

    def errors
      @event.errors.full_messages
    end

    def save_stop_event
      return false unless @ticket.start_event
      Event.transaction do
        @ticket.update!(status: 'completed', completed_at: Time.now)
        @event.assign_attributes(
          measurement: (Time.now - @ticket.start_event.created_at) / 1.hours,
          measurement_type: 'hours_worked'
        )
        @event.save!
        SendTextMessageJob.perform_later(event: event, message: 'completed')
        true
      end
    end
  end
end
