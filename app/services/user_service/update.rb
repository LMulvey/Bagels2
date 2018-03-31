module UserService
  class Update < ApiBaseService
    def call
      user = User.find_by(id: @params[:id])
      user.update!(@params.except(:id))
      user
    end
  end
end