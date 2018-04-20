FactoryBot.define do
  factory :image, class: 'Image' do
    feed
    sequence(:name) {Faker::File.file_name('').split('/')[1]}
  end
end
