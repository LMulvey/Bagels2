# Base TextMessageService
class TextMessageService < ApiBaseService
  def initialize(message:, event: nil, to: Rails.application.secrets.sms_default_number)
    @event = event
    @to = to
    @message = message == 'completed' ? ticket_complete_message : message
  end

  def self.call(message:, event: nil, to: Rails.application.secrets.sms_default_number)
    new(message, event, to).call
  end

  def call
    client = Twilio::REST::Client.new
    client.messages.create(
      from: Rails.application.secrets.twilio_phone_number,
      to: @to,
      body: @message
    )
  end

  private

  def ticket_complete_message
    hours_worked = (@event.ticket.completed_at - @event.ticket.created_at) / 1.hours
    completed_time = @event.ticket.completed_at.strftime('%B %d at %I:%M %p')
    sms_message = "Ticket ##{@event.ticket.id} completed @ #{completed_time}!\n"
    sms_message << "Total hours worked: #{hours_worked.round(1)}"
  end
end
