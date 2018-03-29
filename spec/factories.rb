FactoryBot.define do
  factory :user do
    name "John Smith"
    email "example@example.com"
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