# Job to queue up TextMessageService
class SendTextMessageJob < ApplicationJob
  queue_as :default

  def perform(**params)
    TextMessageService.call(params)
  end
end
