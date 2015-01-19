FactoryGirl.define do
  factory :user_tag do
    name
    search_hash
  end

  sequence :search_hash do |n|
    Digest::SHA256.hexdigest(n.to_s)
  end
end
