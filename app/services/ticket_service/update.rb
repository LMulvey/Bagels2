module TicketService
  class Update < ApiBaseService
    def call
      ticket = Ticket.find_by(id: @params[:id])
      ticket.update!(@params.except(:id))
      if ticket.errors.any?
        response(:unprocessable_entity, ticket.errors.full_messages, nil)
      else
        response(:ok, [], ticket)
      end
    end
  end
end