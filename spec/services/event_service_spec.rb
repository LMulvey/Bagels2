require 'rails_helper'

RSpec.describe EventService do
  before(:each) { ActiveJob::Base.queue_adapter = :test }
  let(:user) { FactoryBot.create(:user) }
  let(:ticket) { FactoryBot.create(:ticket, user_id: user.id) }

  describe '#create' do
    let(:event_hash) { { ticket_id: ticket.id, user_id: user.id, event_type: 'start' } }
    subject(:create_event) { EventService::Create }

    it "creates an event" do
      expect { create_event.call(ticket, event_hash) }.to change { Event.count }.by(1)
    end

    it "disallow invalid event_types" do
      event_hash[:event_type] = 'fakeevent'
      expect { create_event.call(ticket, event_hash) }.to raise_error(ArgumentError)
    end

    it "handles STOP event properly" do
      FactoryBot.create(:event, ticket_id: ticket.id, user_id: user.id, event_type: 'start', created_at: 3.days.ago)
      event_hash[:event_type] = 'stop'
      expect(create_event.call(ticket, event_hash)).to eql(true)
      expect(ticket.reload.status).to eql("completed")
      expect(ticket.completed_at).not_to be_nil
      expect(Event.last.measurement).to eql(72)
      expect(Event.last.measurement_type).to eql("hours_worked")
      expect(SendTextMessageJob).to have_been_enqueued
    end

    it "does not allow STOP events without a START event" do
      event_hash[:event_type] = 'stop'
      expect(create_event.call(ticket, event_hash)).to eql(false)
    end

    it "parent ticket status/completed_at not affected when any other event_type is sent" do
      expect(create_event.call(ticket, event_hash)).to eql(true)
      expect(ticket.reload.status).to eql("active")
      expect(ticket.completed_at).to be_nil
    end
  end

  describe "#update" do
    let(:event) { FactoryBot.create(:event, user_id: user.id, ticket_id: ticket.id, event_type: "start") }
    let(:update_hash) { { event_type: "start" } }
    subject(:update_event) { EventService::Update }

    it "updates an event" do
      update_hash[:event_type] = "delivery" 
      expect(update_event.call(event, update_hash)).to eql(true)
      expect(event.reload.event_type).to eql("delivery")
    end
  end

  describe "#destroy" do
    let(:event) { FactoryBot.create(:event, user_id: user.id, ticket_id: ticket.id, event_type: "stop") }
    subject(:destroy_event) { EventService::Destroy }

    it "destroys an event" do
      expect(destroy_event.call(event)).to eql(true)
      expect { event.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "changes parent ticket to ACTIVE & completed_at to nil when destroy is a STOP event" do
      expect(destroy_event.call(event)).to eql(true)
      expect { event.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(ticket.reload.status).to eql("active")
      expect(ticket.completed_at).to be_nil
    end
  end
end 