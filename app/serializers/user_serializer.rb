class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :access_level
  has_many :tickets
  has_many :events
end
