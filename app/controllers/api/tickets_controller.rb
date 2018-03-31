module Api
  class TicketsController < ApiController
    def index
      handle_index(Ticket, index_params)
    end

    def show
      generate_response(Ticket.find_by(id: params[:id]))
    end

    def create
      new_ticket = TicketService::Create.call(create_params)
      generate_response(new_ticket)
    end

    def update
      call_params = { id: params[:id] }.merge(update_params)
      update_ticket = TicketService::Update.call(call_params)
      generate_response(update_ticket)
    end

    def destroy
      destroy_ticket = TicketService::Destroy.call(id: params[:id])
      generate_response(destroy_ticket)
    end

    private

    def create_params
      params.require(:ticket)
        .permit(:description, :status, :user_id)
    end

    def update_params
      params.require(:ticket)
        .permit(:description, :status, :user_id)
    end
  end
end
