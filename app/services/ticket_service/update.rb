module TicketService
  class Update < ApiBaseService
    def call
      ticket = Ticket.find_by(id: @params[:id])
      ticket.update!(@params.except(:id))
      ticket
    end
  end
end