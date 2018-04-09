module Api
  # EventsController: handles API requests to /events/
  class EventsController < ApiController
    before_filter :load_event, only: %i[update destroy]
    before_filter :load_ticket, only: :create

    def index
      handle_index(Event, index_params)
    end

    def show
      handle_show(Event)
    end

    def create
      if event_policy(params: create_params).can_create_event?
        new_event = EventService::Create.call(
          ticket: @ticket,
          params: create_params
        )

        render(status: :ok, json: new_event.event) && return if new_event
      end

      create_errors = new_event.errors || 'Cannot create event.'
      render(status: :unprocessable_entity, json: { errors: create_errors })
    end

    def update
      if event_policy.can_update_event?
        update_event = EventService::Update.call(
          event: @event,
          params: update_params
        )

        render(status: :ok, json: update_event.event) && return if update_event
      end

      update_errors = update_event.errors || 'Cannot update event.'
      render(status: :unprocessable_entity, json: { errors: update_errors })
    end

    def destroy
      destroy_event = EventService::Destroy.call(@event)
      render(status: :ok, json: destroy_event.event) && return if destroy_event

      destroy_errors = destroy_event.errors || 'Unable to destroy event.'
      render(status: :unprocessable_entity, json: { errors: destroy_errors })
    end

    private

    def create_params
      params.require(:event)
            .permit(:event_type,
                    :ticket_id,
                    :measurement,
                    :measurement_type,
                    :user_id)
    end

    def update_params
      params.require(:event).permit(:measurement, :measurement_type)
    end

    def load_ticket
      @ticket = Ticket.find_by(id: @params[:ticket_id])
    end

    def load_event
      @event = Event.find_by(id: @params[:id])
    end

    def event_policy(params: nil)
      @event_policy ||= EventPolicy.new(
        event: @event || create_params,
        ticket: @ticket || nil,
        params: params
      )
    end
  end
end
