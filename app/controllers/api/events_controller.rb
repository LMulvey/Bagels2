module Api
  class EventsController < ApiController
    def index
      handle_index(Event, index_params)
    end

    def show
      handle_show(Event)
    end

    def create
      handle_response(EventService::Create.call(create_params))
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
  end
end
