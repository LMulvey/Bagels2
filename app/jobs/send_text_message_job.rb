class SendTextMessageJob < ApplicationJob
  queue_as :default

  def perform(params)
    TextMessageService.call(message: params[:message], to: params[:to])
  end
end
