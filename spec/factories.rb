FactoryBot.define do
  factory :user do
    first_name "John"
    last_name "Smith"
    email "example@example.com"
  end
end

FactoryBot.define do
  factory :ticket do
    user_id 1
    description "Test"
  end
end

FactoryBot.define do
  factory :event do
    event_type "start"
    ticket_id 1
  end
end