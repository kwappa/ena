class UserTag < ActiveRecord::Base
  has_many :user_taggings
  has_many :users, through: :user_taggings
end
