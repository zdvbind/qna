FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    association :votable, factory: :question

    trait :like do
      value { 1 }
    end

    trait :dislike do
      value { -1 }
    end
  end
end
