module Api
  class EventsController < ApiController
    def index
      render json: Event.all
    end

    def show
      render json: Event.find_by(id: params[:id])
    end

    def create
    end
  end
end
