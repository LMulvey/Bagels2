module UserService
  class CreateUser
    def initialize(params = {})
      @user_params = {
        # Set default params here if required
      }.merge(params)
    end

    def call
      User.create(@user_params)
    end      
  end
end