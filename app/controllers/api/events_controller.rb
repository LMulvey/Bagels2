module Api
  class EventsController < ApiController
    before_action: :load_ticket, only: [:create, :update]

    def index
      handle_index(Event, index_params)
    end

    def show
      handle_show(Event)
    end

    def create
      if ticket_policy.can_create_event?
        new_event = EventService::Create.call(
          ticket: @ticket,
          params: create_params)

        render(
          status: :ok, 
          json: new_event) if new_event

        render(
          status: :unprocessable_entity, 
          json: { errors: new_event.errors.full_messages }) if new_event.blank?
      else
        render(
          status: :unprocessable_entity, 
          json: { errors: "Cannot create event." })
      end
    end

    def update
      call_params = { id: params[:id] }.merge(update_params)
      update_event = EventService::Update.call(call_params)
      handle_response(update_event)
    end

    def destroy
      destroy_event = EventService::Destroy.call(id: params[:id])
      handle_response(destroy_event)
    end

    private

    def create_params
      params.require(:event)
        .permit(:event_type, :ticket_id, :measurement, :measurement_type, :user_id)
    end

    def update_params
      params.require(:event)
        .permit(:event_type, :ticket_id, :measurement, :measurement_type, :user_id)
    end

    def load_ticket
      @ticket = Ticket.find_by(id: @params[:ticket_id])      
    end

    def ticket_policy
      @ticket_policy ||= TicketPolicy.new(
        ticket:    @ticket, 
        event:     create_params)
    end
  end
end
