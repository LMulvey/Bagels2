require 'rails_helper'

RSpec.describe Event, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @ticket = FactoryBot.create(:ticket, user_id: @user.id)
    @event = FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id)  
  end

  it "properly relates to cooresponding user" do
    expect(@event.reload.user).to eq(@user)
  end

  it "properly relates to cooresponding ticket" do
    expect(@event.reload.ticket).to eq(@ticket)
  end

  it "does not accept types other than start, stop, delivery, or pickup" do
    ["start", "stop", "delivery", "pickup"].each { | event_type |
      expect { FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id, event_type: event_type) }.not_to raise_error
    }
    expect { 
      FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id, event_type: "Storped") 
    }.to raise_error(ArgumentError)
  end
end
