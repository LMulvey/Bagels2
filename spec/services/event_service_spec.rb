require 'rails_helper'

RSpec.describe EventService do
  before(:each) do
    @user = FactoryBot.create(:user)
    @ticket = FactoryBot.create(:ticket, user_id: @user.id)
  end

  it "creates an event" do
    before_count = Event.count
    event = { ticket_id: @ticket.id, event_type: "start", user_id: @user.id }
    expect(EventService::CreateEvent.call(event)).to be_instance_of(Event)
    expect(Event.count).to eq(before_count + 1)
  end

  it "sets parent ticket to COMPLETED when STOP event is sent" do
    expect(@ticket.status).to eq("active")
    event = { ticket_id: @ticket.id, event_type: "stop", user_id: @user.id }
    expect(EventService::CreateEvent.call(event)).to eq(true)
    expect(@ticket.reload.status).to eq("completed")
  end

  it "does not change Ticket status when any other event is sent" do
    expect(@ticket.status).to eq("active")
    event = { ticket_id: @ticket.id, event_type: "start", user_id: @user.id }
    expect(EventService::CreateEvent.call(event)).to be_instance_of(Event)
    expect(@ticket.reload.status).to eq("active")
  end
end 