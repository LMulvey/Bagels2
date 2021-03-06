class Event < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  
  enum event_type: { start: 0, delivery: 1, pickup: 2, stop: 3 }
  validates :event_type, presence: true
end
