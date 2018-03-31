FactoryBot.define do
  sequence :email do |n|
    "starboy#{n}@gmail.com"
  end

  factory :user do
    name "John Smith"
    email
  end

  factory :ticket do
    user_id 1
    description "Test"
  end

  factory :event do
    event_type "start"
    ticket_id 1
  end
end