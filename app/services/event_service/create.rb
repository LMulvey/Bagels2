module EventService
  class Create < ApiBaseService
    def call
      return false if ticket_is_completed
      
      if @params[:event_type] === "stop"
        handle_stop_event
      else 
        Event.create!(@params)
      end
    end

    private

    def handle_stop_event
      @event = Event.new(@params)
      Event.transaction do
        ticket = Ticket.find_by!(id: @params[:ticket_id])
        ticket.update!(:status => "completed", :completed_at => DateTime.now)
        @event.save!
      end
      @event
    end

    def ticket_is_completed
      ticket = Ticket.find_by(id: @params[:ticket_id])
      true if ticket.status === "completed"
    end
  end
end