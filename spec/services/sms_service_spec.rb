require 'rails_helper'

RSpec.describe TextMessageService do
  it "successfully sends a message when called" do
    TextMessageService.call(message: "Hey!")
    last_message = FakeSMS.messages.last
    expect(last_message.body).to eq("Hey!")
  end

  it "accepts a different 'to' phone number" do
    TextMessageService.call(message: "Hey!", to: 17809999999)
    last_message = FakeSMS.messages.last
    expect(last_message.to).to eq(17809999999)
  end
end