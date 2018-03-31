require 'rails_helper'

RSpec.describe "UserModel", type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @ticket = FactoryBot.create(:ticket, user_id: @user.id)
    @event = FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id)  
  end

  it "properly relates to cooresponding tickets" do
    10.times { FactoryBot.create(:ticket, user_id: @user.id) }
    expect(@user.reload.tickets.count).to eq(11)
  end

  it "properly relates to cooresponding events" do
    10.times { FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id) }
    expect(@user.reload.events.count).to eq(11)
  end
end
