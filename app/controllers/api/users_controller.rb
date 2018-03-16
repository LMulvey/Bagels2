module Api
  class UsersController < ApiController
    def index
      render json: User.all
    end

    def show
      render json: User.find_by(id: params[:id])
    end

    def create
      new_user = UserService::CreateUser.new(create_params).call
      render(json: { 
        status: new_user.errors.any? ? 422 : 200,
        errors: new_user.errors.full_messages, 
        record: new_user  
      })
    end

    private

    def create_params
      params.require(:user)
        .permit(:first_name, :last_name, :email, :access_level)
    end
  end
end
