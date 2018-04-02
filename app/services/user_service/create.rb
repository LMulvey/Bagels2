module UserService
  class Create < ApiBaseService
    def call
      new_user = User.create!(@params)
      if new_user.errors.any?
        response(:unprocessable_entity, new_user.errors.full_messages, nil)
      else
        response(:ok, [], new_user)
      end
    end      
  end
end