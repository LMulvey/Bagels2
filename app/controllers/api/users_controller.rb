module Api
  class UsersController < ApiController
    def index
      handle_index(User)
    end

    def show
      generate_response(User.find_by(id: params[:id]))
    end

    def create
      new_user = UserService::CreateUser.call(create_params)
      generate_response(new_user)
    end

    private

    def create_params
      params.require(:user)
        .permit(:first_name, :last_name, :email, :access_level)
    end
  end
end
