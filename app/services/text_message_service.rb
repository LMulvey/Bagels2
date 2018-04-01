class TextMessageService
  attr_reader :message

  def initialize(message, to)
    @message = message
    @to = to
  end

  def self.call(message, to = Rails.application.secrets.sms_default_number)
    new(message, to).call
  end

  def call
    client = Twilio::REST::Client.new    
    client.messages.create(
      from: Rails.application.secrets.twilio_phone_number,
      to: @to,
      body: @message
    )
  end
end