class UserResume < ActiveRecord::Base
  belongs_to :user
  include Renderable
end
