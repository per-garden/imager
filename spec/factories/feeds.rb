FactoryBot.define do
  factory :feed do
    sequence(:name) {Faker::Lorem.word}
    upload_url ''
    count Random.rand(2...6)
    geometry "6#{Random.rand(10).to_s}0x4#{Random.rand(10).to_s}0"

    factory :bad_feed1 do
      name 'Bad Name  !%'
    end

    factory :bad_feed2 do
      geometry "Golden Ratio"
    end

    factory :test_feed do
      name 'test'
      count 2
      upload_url "https://drive.google.com/open?id=XXX"
    end
  end
end
