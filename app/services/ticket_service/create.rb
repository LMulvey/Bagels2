module TicketService
  class Create < ApiBaseService   
    def call
      Ticket.create!(@params)
    end
  end
end