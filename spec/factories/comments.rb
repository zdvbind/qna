FactoryBot.define do
  factory :comment do
    association :user
    association :commentable, factory: :question

    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
