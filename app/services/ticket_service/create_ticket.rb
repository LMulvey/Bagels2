module TicketService
  class CreateTicket
    def initialize(params = {})
      @ticket_params = {
        :status => 'active'
      }.merge(params)
    end

    def call
      return Ticket.create!(@ticket_params)
    end
  end
end