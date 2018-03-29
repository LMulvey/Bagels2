class Ticket < ApplicationRecord
  belongs_to :user
  has_many :events
  enum status: { active: 0, completed: 1 }
  validates :description, presence: true
  validates :status, presence: true
end
