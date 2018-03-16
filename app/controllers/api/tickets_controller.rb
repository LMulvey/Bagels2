module Api
  class TicketsController < ApiController
    def index
      handle_index(Ticket)
    end

    def show
      generate_response(Ticket.find_by(id: params[:id]))
    end

    def create
      new_ticket = TicketService::CreateTicket.new(create_params).call
      generate_response(new_ticket)
    end

    private

    def create_params
      params.require(:ticket)
        .permit(:description, :status, :user_id)
    end
  end
end
