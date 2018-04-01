module EventService
  class Create < ApiBaseService
    def call
      return false if ticket_is_completed

      if @params[:event_type] === "stop"
        handle_stop_event
      elsif measurement_required && measurement_not_present
        raise ArgumentError
      else
        Event.create!(@params)
      end
    end

    private

    def handle_stop_event
      @event = Event.new(@params)
      is_successful = Event.transaction do
          ticket = Ticket.find_by!(id: @params[:ticket_id])
          ticket.update!(:status => "completed", :completed_at => DateTime.now)
          @event.save!
        end
      if is_successful
        SendTextMessageJob.perform_later(ticket_complete_message)        
        @event
      else
        false
      end
    end

    def ticket_is_completed
      ticket = Ticket.find_by(id: @params[:ticket_id])
      true if ticket.status === "completed"
    end

    def measurement_required
      @params[:event_type] === "pickup" || @params[:event_type] === "delivery"
    end

    def measurement_not_present
      return true if @params[:measurement].blank?|| @params[:measurement_type].blank?
      false
    end

    def ticket_complete_message
      hours_worked = (@event.ticket.completed_at - @event.ticket.created_at) / 1.hours
      sms_message = "Ticket ##{@event.ticket.id} has been COMPLETED as of #{@event.ticket.completed_at}!\n"
      sms_message += "Total hours worked: #{hours_worked}"
    end
  end
end
