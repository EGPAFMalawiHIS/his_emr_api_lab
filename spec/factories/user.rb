FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.first_name }
    password { 'password' }
    person { create(:person, creator: nil) }
  end
end
