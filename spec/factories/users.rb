require 'faker'

FactoryGirl.define do
  factory :user do
    username { 'testuser' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password 'please'
    password_confirmation 'please'

    factory :admin do
      admin true
    end
  end
end
