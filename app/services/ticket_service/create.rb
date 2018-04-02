module TicketService
  class Create < ApiBaseService   
    def call
      new_ticket = Ticket.create!(@params)
      if new_ticket.errors.any?
        response(:unprocessable_entity, new_ticket.errors.full_messages, nil)
      else
        response(:ok, [], new_ticket)
      end
    end
  end
end