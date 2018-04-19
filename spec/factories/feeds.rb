FactoryBot.define do
  factory :feed do
    sequence(:name) {Faker::Lorem.word}
    count Random.rand(2...6)
    factory :bad_feed do
      name 'Bad Name  !%'
    end
  end
end
