class EventSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :measurement, :measurement_type, :created_at, :updated_at
  belongs_to :ticket
  belongs_to :user
end
