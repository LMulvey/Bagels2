module Api
  class EventsController < ApiController
    def index
      handle_index(Event, index_params)
    end

    def show
      generate_response(Event.find_by(id: params[:id]))
    end

    def create
      generate_response(EventService::CreateEvent.call(create_params))
    end

    private

    def create_params
      params.require(:event)
        .permit(:event_type, :ticket_id, :user_id)
    end

    def index_params
      { limit: params[:limit], offset: params[:offset] }
    end
  end
end
