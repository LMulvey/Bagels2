class TextMessageService < ApiBaseService
  def call
    client = Twilio::REST::Client.new    
    client.messages.create(
      from: Rails.application.secrets.twilio_phone_number,
      to: @params[:to] || Rails.application.secrets.sms_default_number,
      body: @params[:message]
    )
  end
end