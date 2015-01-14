class UserTagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag, class_name: 'UserTag', foreign_key: 'user_tag_id'
end
