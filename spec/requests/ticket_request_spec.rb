require 'rails_helper'

RSpec.describe "Tickets - Request Spec", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe "GET /tickets" do
    it "returns status 200" do
      get api_tickets_path      
      expect(response).to have_http_status(:ok)
    end

    it "returns JSON object" do
      get api_tickets_path      
      expect(response.content_type).to eq('application/json')
    end

    describe "Pagination" do
      it "enforces record limit" do
        6.times { FactoryBot.create(:ticket, description: "Wow!", user_id: @user.id) }
        get api_tickets_path, params: { limit: 5 }
        expect(response_body.count).to eq(5)
      end

      it "returns appropriate pages" do
        10.times { FactoryBot.create(:ticket, description: "Wow!", user_id: @user.id) }
        first_id = Ticket.first.id
        last_id = Ticket.last.id
        get api_tickets_path, params: { limit: 5, page: 2 }
        expect(response_body.count).to eq(5)

        # Returns data in DESC by created_at by default
        expect(response_body[0]["id"]).to eq(last_id)
        expect(response_body[4]["id"]).to eq(first_id + 5)
      end
    end
  end

  describe "GET /tickets/:id" do
    it "returns status 404 if ticket is not found" do
      get api_ticket_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end

    it "returns JSON with matching schema" do
      ticket = FactoryBot.create(:ticket, description: "Hey!", user_id: @user.id)
      get api_ticket_path(id: ticket.id)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
      expect(response).to match_response_schema("ticket")
    end
  end

  # Methods
  def response_body
    JSON.parse(response.body)
  end
end
