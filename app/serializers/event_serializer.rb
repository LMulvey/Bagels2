class EventSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :ticket
  belongs_to :user
end
