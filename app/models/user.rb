class User < ApplicationRecord
  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  has_many :tickets
  has_many :events
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, :with => EMAIL_REGEXP, :on => :create
end
