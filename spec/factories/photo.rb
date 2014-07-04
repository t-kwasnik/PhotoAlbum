FactoryGirl.define do
  factory :photo do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'test.jpg')) }
    user
    city
    state
    country
  end
end
