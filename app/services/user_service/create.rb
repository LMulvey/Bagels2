module UserService
  class Create < ApiBaseService
    def call
      User.create!(@params)
    end      
  end
end