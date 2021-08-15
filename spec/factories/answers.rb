FactoryBot.define do
  factory :answer do
    body { 'MyBody' }
    association :author, factory: :user
    question
  end

  trait :invalid do
    body { nil }
  end
end
