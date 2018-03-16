module Api
  class EventsController < ApiController
    def index
      handle_index(Event)
    end

    def show
      generate_response(Event.find_by(id: params[:id]))
    end

    def create
      new_event = EventService::CreateEvent.new(create_params).call
      generate_response(new_event)
    end

    private

    def create_params
      params.require(:event)
        .permit(:event_type, :ticket_id)
    end
  end
end
