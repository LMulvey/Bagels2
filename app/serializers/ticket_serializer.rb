class TicketSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :description, :completed_at, :created_at, :updated_at
  belongs_to :user
  has_many :events
end
