require 'rails_helper'

RSpec.describe EventService do
  before(:each) do
    @user = FactoryBot.create(:user)
    @ticket = FactoryBot.create(:ticket, user_id: @user.id)
  end

  describe "::Create" do
    it "creates an event" do
      before_count = Event.count
      event = { ticket_id: @ticket.id, event_type: "start", user_id: @user.id }
      expect(EventService::Create.call(event)).to be_instance_of(Event)
      expect(Event.count).to eq(before_count + 1)
    end

    it "does not allow invalid event_types" do
      event = { ticket_id: @ticket.id, user_id: @user.id, event_type: "fakeevent" }      
      expect { EventService::Create.call(event) }.to raise_error(ArgumentError)
    end

    it "parent ticket status set to COMPLETED, completed_at set when event_type: stop" do
      expect(@ticket.status).to eq("active")
      event = { ticket_id: @ticket.id, event_type: "stop", user_id: @user.id }
      expect(EventService::Create.call(event)).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("completed")
      expect(@ticket.completed_at).not_to be_nil
    end

    it "parent ticket status/completed_at not affected when any other event_type is sent" do
      expect(@ticket.status).to eq("active")
      event = { ticket_id: @ticket.id, event_type: "start", user_id: @user.id }
      expect(EventService::Create.call(event)).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("active")
      expect(@ticket.completed_at).to be_nil
    end

    it "will not create an event if ticket status is 'completed'" do
      completed_ticket = FactoryBot.create(:ticket, user_id: @user.id, status: "completed")
      event = { ticket_id: completed_ticket.id, user_id: @user.id, event_type: "start" }
      expect(EventService::Create.call(event)).to eq(false)
    end
  end

  describe "::Update" do
    before(:each) do
      @event = FactoryBot.create(:event, user_id: @user.id, ticket_id: @ticket.id, event_type: "start")
    end

    it "updates an event" do
      update_hash = { id: @event.id, event_type: "delivery" }
      expect(EventService::Update.call(update_hash)).to be_instance_of(Event)
      expect(@event.reload.event_type).to eq("delivery")
    end

    it "does not allow invalid event_types" do
      update_hash = { id: @event.id, event_type: "fakeevent" }      
      expect { EventService::Update.call(update_hash) }.to raise_error(ArgumentError)
    end

    it "changes parent ticket to COMPLETED & completed_at when update is a STOP event" do
      update_hash = { id: @event.id, event_type: "stop" }
      expect(@ticket.status).to eq("active")
      expect(EventService::Update.call(update_hash)).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("completed")
      expect(@event.reload).to eq(@event)
    end
  end

  describe "::Destroy" do
    before(:each) do
      @event = FactoryBot.create(:event, user_id: @user.id, ticket_id: @ticket.id, event_type: "start")
    end

    it "destroys an event" do
      expect(EventService::Destroy.call(@event.id)).to be_instance_of(Event)
      expect { @event.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "changes parent ticket to ACTIVE & completed_at to nil when destroy is a STOP event" do
      update_hash = { id: @event.id, event_type: "stop" }
      expect(@ticket.status).to eq("active")
      expect(EventService::Update.call(update_hash)).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("completed")
      expect(@event.reload).to eq(@event)
      expect(EventService::Destroy.call(@event.id)).to be_instance_of(Event)
      expect { @event.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(@ticket.reload.status).to eq("active")
      expect(@ticket.completed_at).to be_nil
    end
  end
end 