require 'rails_helper'

RSpec.describe TicketService do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe "::Create" do
    it "creates a ticket" do
      before_count = Ticket.count
      ticket = { user_id: @user.id, description: "Wow!" }
      expect(TicketService::Create.call(ticket)).to be_instance_of(Ticket)
      expect(Ticket.count).to eq(before_count + 1)
    end

    it "does not allow invalid status types" do
      ticket = { user_id: @user.id, description: "Wow!", status: "FakeStatus" }
      expect { TicketService::Create.call(ticket) }.to raise_error(ArgumentError)
    end
  end

  describe "::Update" do
    before(:each) do
      @ticket = FactoryBot.create(:ticket, user_id: @user.id, description: "Wow!")
    end

    it "updates a ticket" do
      update_hash = { id: @ticket.id, description: "Double wow!" }
      expect(TicketService::Update.call(update_hash)).to be_instance_of(Ticket)
      expect(@ticket.reload.description).to eq("Double wow!")
    end

    it "does not allow invalid status_types" do
      update_hash = { id: @ticket.id, status: "FakeStatus" }     
      expect { TicketService::Update.call(update_hash) }.to raise_error(ArgumentError)
    end
  end

  describe "::Destroy" do
    before(:each) do
      @ticket = FactoryBot.create(:ticket, user_id: @user.id, description: "Wow!")
    end

    it "destroys a ticket and all its events" do
      10.times { FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id) }
      expect(@ticket.events.count).to eq(10)
      expect(TicketService::Destroy.call(@ticket.id)).to be_instance_of(Ticket)
      expect(Event.find_by(ticket_id: @ticket.id)).to be_nil
      expect { @ticket.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end 