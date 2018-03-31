require 'rails_helper'

RSpec.describe UserService do
  before(:each) do
    @user = FactoryBot.create(:user, email: "test@test.com", name: "Jeff Smith")
    FactoryBot.create(:user, email: "exists@email.com")
  end

  describe "::Create" do
    it "creates a user" do
      before_count = User.count
      user = { name: "Johnny Boy", email: "dogs@dogs.com" }
      expect(UserService::Create.call(user)).to be_instance_of(User)
      expect(User.count).to eq(before_count + 1)
    end

    it "does not allow duplicate emails" do
      user = { name: "John Martin", email: "test@test.com" }
      expect { UserService::Create.call(user) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "::Update" do
    it "updates a User" do
      update_hash = { id: @user.id, name: "Jeffery Biggs" }
      expect(UserService::Update.call(update_hash)).to be_instance_of(User)
      expect(@user.reload.name).to eq("Jeffery Biggs")
    end

    it "does not allow duplicate emails" do
      update_hash = { id: @user.id, email: "exists@email.com" }     
      expect { UserService::Update.call(update_hash) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "::Destroy" do
    it "destroys a user" do
      expect(UserService::Destroy.call(@user.id)).to be_instance_of(User)
      expect { @user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end 