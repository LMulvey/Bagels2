require 'rails_helper'

RSpec.describe EventService do
  before(:each) do
    ActiveJob::Base.queue_adapter = :test
    @user = FactoryBot.create(:user)
    @ticket = FactoryBot.create(:ticket, user_id: @user.id)
  end

  describe "::Create" do
    it "creates an event" do
      before_count = Event.count
      event = { ticket_id: @ticket.id, event_type: "start", user_id: @user.id }
      result = EventService::Create.call(@ticket, event)
      expect(result[:record]).to be_instance_of(Event)
      expect(Event.count).to eq(before_count + 1)
    end

    it "does not allow invalid event_types" do
      event = { ticket_id: @ticket.id, user_id: @user.id, event_type: "fakeevent" }      
      expect { EventService::Create.call(@ticket, event) }.to raise_error(ArgumentError)
    end

    it "requires measurement and measurement_type if event_type is pickup or delivery" do
      ["delivery", "pickup"].each do | event_type |
        create_hash = { ticket_id: @ticket.id, user_id: @user.id, event_type: event_type }
        result = EventService::Create.call(@ticket, create_hash)
        expect(result[:errors]).not_to be_empty
        measured = { measurement: 400, measurement_type: "bagels" }.merge(create_hash)
        new_result = EventService::Create.call(@ticket, measured)
        expect(new_result[:record]).to be_instance_of(Event)
      end
    end

    it "measurements set to hours worked, parent ticket set COMPLETED, completed_at set, SMS job queued when event_type: stop" do
      expect(@ticket.status).to eq("active")
      FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id, event_type: "start", created_at: 3.days.ago)
      event = { ticket_id: @ticket.id, event_type: "stop", user_id: @user.id }
      result = EventService::Create.call(@ticket, event)
      expect(result[:record]).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("completed")
      expect(@ticket.completed_at).not_to be_nil
      expect(Event.last.measurement).to eq(72)
      expect(Event.last.measurement_type).to eq("hours_worked")
      expect(SendTextMessageJob).to have_been_enqueued
    end

    it "does not allow STOP events without a START event" do
      event = { ticket_id: @ticket.id, event_type: "stop", user_id: @user.id }
      result = EventService::Create.call(@ticket, event)
      expect(result[:errors][0]).to eq("Start event required before issuing stop event.")
      expect(result[:record]).to be_nil
    end

    it "parent ticket status/completed_at not affected when any other event_type is sent" do
      expect(@ticket.status).to eq("active")
      event = { ticket_id: @ticket.id, event_type: "start", user_id: @user.id }
      result = EventService::Create.call(@ticket, event)
      expect(result[:record]).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("active")
      expect(@ticket.completed_at).to be_nil
    end

    it "will not create an event if ticket status is 'completed'" do
      completed_ticket = FactoryBot.create(:ticket, user_id: @user.id, status: "completed")
      event = { ticket_id: completed_ticket.id, user_id: @user.id, event_type: "start" }
      result = EventService::Create.call(completed_ticket, event)
      expect(result[:errors]).not_to be_empty
    end
  end

  describe "::Update" do
    before(:each) do
      @event = FactoryBot.create(:event, user_id: @user.id, ticket_id: @ticket.id, event_type: "start")
    end

    it "updates an event" do
      update_hash = { id: @event.id, event_type: "delivery" }
      update = EventService::Update.call(update_hash)
      expect(update[:record]).to be_instance_of(Event)
      expect(@event.reload.event_type).to eq("delivery")
    end

    it "does not allow invalid event_types" do
      update_hash = { id: @event.id, event_type: "fakeevent" }      
      expect { EventService::Update.call(update_hash) }.to raise_error(ArgumentError)
    end

    it "does not allow STOP events without a START event" do
      new_ticket = FactoryBot.create(:ticket, user_id: @user.id)
      new_event = FactoryBot.create(:event, user_id: @user.id, ticket_id:  new_ticket.id, event_type: "delivery", measurement_type: "hours_worked", measurement: 41)
      event = { id: new_event.id, event_type: "stop", user_id: @user.id }
      result = EventService::Update.call(event)
      expect(result[:errors][0]).not_to be_empty
      expect(result[:record]).to be_nil
    end

    it "measurements set to hours worked, parent ticket set COMPLETED, completed_at set, SMS job queued when event_type: stop" do
      FactoryBot.create(:event, ticket_id: @ticket.id, user_id: @user.id, event_type: "start")
      update_hash = { id: @event.id, event_type: "stop" }
      expect(@ticket.status).to eq("active")
      result = EventService::Update.call(update_hash)
      expect(result[:record]).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("completed")
      expect(@event.reload).to eq(@event)
      expect(@event.reload.measurement).not_to be_nil
      expect(@event.reload.measurement_type).to eq("hours_worked")
      expect(SendTextMessageJob).to have_been_enqueued
    end
  end

  describe "::Destroy" do
    before(:each) do
      @event = FactoryBot.create(:event, user_id: @user.id, ticket_id: @ticket.id, event_type: "start")
    end

    it "destroys an event" do
      result = EventService::Destroy.call(id: @event.id)
      expect(result[:record]).to be_instance_of(Event)
      expect { @event.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "changes parent ticket to ACTIVE & completed_at to nil when destroy is a STOP event" do
      update_hash = { id: @event.id, event_type: "stop" }
      expect(@ticket.status).to eq("active")
      result = EventService::Update.call(update_hash)
      expect(result[:record]).to be_instance_of(Event)
      expect(@ticket.reload.status).to eq("completed")
      expect(@event.reload).to eq(@event)
      destroy = EventService::Destroy.call(id: @event.id)
      expect(destroy[:record]).to be_nil
      expect { @event.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(@ticket.reload.status).to eq("active")
      expect(@ticket.completed_at).to be_nil
    end
  end
end 