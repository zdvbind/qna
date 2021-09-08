FactoryBot.define do
  factory :answer do
    body { 'MyBody' }
    association :author, factory: :user
    question
  end

  trait :invalid do
    body { nil }
  end

  trait :with_attachments do
    after :create do |answer|
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb')
    end
  end
end
