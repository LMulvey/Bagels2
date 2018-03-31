module Api
  class UsersController < ApiController
    def index
      handle_index(User, index_params)
    end

    def show
      generate_response(User.find_by(id: params[:id]))
    end

    def create
      new_user = UserService::Create.call(create_params)
      generate_response(new_user)
    end

    def create
      call_params = { id: params[:id] }.merge(update_params)
      update_user = UserService::Update.call(call_params)
      generate_response(update_user)
    end

    def create
      destroy_user = UserService::Destroy.call(params[:id])
      generate_response(destroy_user)
    end

    private

    def create_params
      params.require(:user)
        .permit(:name, :email, :access_level)
    end

    def update_params
      params.require(:user)
        .permit(:name, :email, :access_level)
    end
  end
end
