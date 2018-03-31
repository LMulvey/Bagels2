module TicketService
  class Destroy
    def self.call(id)
      @ticket = Ticket.find_by(id: id)
      @ticket.destroy!
    end
  end
end