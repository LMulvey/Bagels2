class Ticket < ApplicationRecord
  belongs_to :user
  has_many :events, dependent: :destroy
  
  enum status: { active: 0, completed: 1 }
  validates :description, presence: true
  validates :status, presence: true

  def start_event
    events.find_by(event_type: "start")
  end
end
