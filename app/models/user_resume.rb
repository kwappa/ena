class UserResume < ActiveRecord::Base
  include Renderable

  belongs_to :user

  after_save :touch_user

  def touch_user
    user.touch
  end
end
