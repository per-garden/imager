FactoryBot.define do
  factory :image, class: 'Image' do
    feed
    sequence(:file_name) {Faker::File.file_name('').split('/')[1]}
    geometry "420x680"

    factory :bad_image do
      geometry "Golden Ratio"
    end
  end
end
