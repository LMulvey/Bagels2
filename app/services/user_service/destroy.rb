module UserService
  class Destroy < ApiBaseService
    def call
      @user = User.find_by(id: @params[:id])
      @user.destroy!
      if @user.errors.any?
        response(:unprocessable_entity, @user.errors.full_messages, nil)
      else
        response(:ok, [], @user)
      end
    end
  end
end