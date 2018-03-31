require 'rails_helper'

RSpec.describe "TicketModel", type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @ticket = FactoryBot.create(:ticket, user_id: @user.id)
    @event = FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id)  
  end

  it "properly relates to cooresponding user" do
    expect(@ticket.reload.user).to eq(@user)
  end

  it "properly relates to cooresponding events" do
    10.times { FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id) }
    expect(@ticket.reload.events.count).to eq(11)
  end

  it "does not accept statues other than active and completed" do
    ["active", "completed"].each { | status |
      expect { FactoryBot.create(:ticket, user_id: @user.id, status: status) }.not_to raise_error
    }
    expect { 
      FactoryBot.create(:ticket,user_id: @user.id, status: "Storped") 
    }.to raise_error(ArgumentError)
  end
end
