class UserResume < ActiveRecord::Base
  include Renderable

  belongs_to :user

  after_create :record_first_diff
  after_save :touch_user

  def touch_user
    user.touch
  end

  def update_body(content)
    old_body = self.body.strip
    result = update_attributes(body: content.strip)

    if result
      UserResumeHistory.record_diff(self.user_id, old_body, self.body)
    end
    result
  end

  def record_first_diff
    UserResumeHistory.record_diff(self.user_id, '', self.body)
  end
end
