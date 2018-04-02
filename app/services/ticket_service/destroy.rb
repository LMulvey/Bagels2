module TicketService
  class Destroy < ApiBaseService
    def call
      @ticket = Ticket.find_by(id: @params[:id])
      @ticket.destroy!
      if @ticket.errors.any?
        response(:unprocessable_entity, @ticket.errors.full_messages, nil)
      else
        response(:ok, [], @ticket)
      end
    end
  end
end