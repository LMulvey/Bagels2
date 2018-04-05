module EventService
  class Create < ApiBaseService
    attr_reader :event

    def initialize(ticket, params)
      @ticket = ticket
      @params = params

      build
    end

    def call
      return save_stop_event if @params[:event_type] === "stop"
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

    def save_stop_event
      Event.transaction do
        @ticket.update!(:status => "completed", :completed_at => Time.now)
        @event.assign_attributes(
          measurement:      (completion_time - ticket.start_event.created_at) / 1.hours,
          measurement_type: "hours_worked"
        )
        @event.save!
        SendTextMessageJob.perform_later(ticket_complete_message(@event))        
      end
    end
  end
end
