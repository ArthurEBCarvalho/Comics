FactoryBot.define do
  factory :user do
    email { "user_#{rand(10000000)}@email.com" }
    password { '123456' }
  end
end
