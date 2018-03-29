module TicketService
  class CreateTicket
    def initialize(params = {})
      @ticket_params = {
        :status => 'active'
      }.merge(params)
    end

    def self.call(params = {})
      new(params).call
    end      

    def call
      Ticket.create!(@ticket_params)
    end
  end
end