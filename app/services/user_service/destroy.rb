module UserService
  class Destroy
    def self.call(id)
      @user = User.find_by(id: id)
      @user.destroy!
    end
  end
end