module Api
  class UsersController < ApiController
    def index
      handle_index(User, index_params)
    end

    def show
      handle_show(User)
    end

    def create
      new_user = UserService::Create.call(create_params)
      handle_response(new_user)
    end

    def update
      call_params = { id: params[:id] }.merge(update_params)
      update_user = UserService::Update.call(call_params)
      handle_response(update_user)
    end

    def destroy
      destroy_user = UserService::Destroy.call(id: params[:id])
      handle_response(destroy_user)
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
