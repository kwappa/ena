FactoryGirl.define do
  factory :user do
    name
    nick
    email
    password 'password'
  end

  sequence :email do |n|
    "user_#{n}@example.com"
  end

  sequence :name do |n|
    chars = ('a'..'z').to_a
    idx = n % chars.size
    "#{chars[idx].upcase}#{chars.sample(rand(9) + 2).join}#{n}"
  end

  sequence :nick do |n|
    chars = ('a'..'z').to_a
    idx = n % chars.size
    "#{chars[idx].upcase}#{chars.sample(rand(9) + 2).join}#{n}"
  end
end
