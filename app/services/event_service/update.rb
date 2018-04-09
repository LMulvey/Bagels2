module EventService
  # EventService.Update: handles updating of events
  class Update < ApiBaseService
    attr_reader :event

    def initialize(event, params)
      @event = event
      @params = params

      build
    end

    def self.call(event, params)
      new(event, params).call
    end

    def call
      if @event.save!
        true
      else
        false
      end
    end

    private

    def build
      @event.assign_attributes(@params)
    end

    def errors
      @event.errors.full_messages
    end
  end
end
