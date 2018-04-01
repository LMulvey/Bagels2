class SendTextMessageJob < ApplicationJob
  queue_as :default

  def perform(message, to = Rails.application.secrets.sms_default_number)
    TextMessageService.call(message, to)
  end
end
