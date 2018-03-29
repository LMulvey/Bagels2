require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /events" do
    it "returns status 200" do
      get api_events_path      
      expect(response).to have_http_status(:ok)
    end

    it "returns JSON object" do
      get api_events_path      
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "GET /events/:id" do
    it "returns status 404 if event is not found" do
      get api_event_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end

    it "returns JSON with a valid event ID" do
      get api_event_path(id: 1)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end
  end
end
