class ApiBaseService
  def initialize(params)
    @params = params
  end

  def self.call(params)
    new(params).call
  end

  private

  def response(status, errors, record)
    { status: status, errors: errors, record: record }
  end

  def ticket_complete_message(event)
    hours_worked = (event.ticket.completed_at - event.ticket.created_at) / 1.hours
    completed_time = event.ticket.completed_at.strftime("%B %d at %I:%M %p")
    sms_message = "Ticket ##{event.ticket.id} has been COMPLETED as of #{completed_time}!\n"
    sms_message += "Total hours worked: #{hours_worked.round(1)}"
  end
end
