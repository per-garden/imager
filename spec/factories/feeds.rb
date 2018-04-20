FactoryBot.define do
  factory :feed do
    sequence(:name) {Faker::Lorem.word}
    count Random.rand(2...6)
    geometry "420x680"

    factory :bad_feed1 do
      name 'Bad Name  !%'
    end

    factory :bad_feed2 do
      geometry "Golden Ratio"
    end

    factory :test_feed do
      name 'test'
    end
  end
end
