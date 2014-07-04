FactoryGirl.define do
  factory :photo do
    geom "POINT(-111.79516666666666 40.57299999999999 1610.0)"
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'test1.jpg')) }
    user
    city
    state
    country
  end
end
