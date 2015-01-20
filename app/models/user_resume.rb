class UserResume < ActiveRecord::Base
  include Renderable

  belongs_to :user

  before_create :prepare_body

  after_create :record_first_diff
  after_save :touch_user

  def touch_user
    user.touch
  end

  def update_body(content)
    old_body = self.body
    new_body = self.class.strip_and_unify_newline(content)
    result = update_attributes(body: new_body)

    if result
      UserResumeHistory.record_diff(self.user_id, old_body, new_body)
    end
    result
  end

  def record_first_diff
    UserResumeHistory.record_diff(self.user_id, '', self.body)
  end

  def self.strip_and_unify_newline(str)
    str.strip.gsub(/\r\n|\r|\n/, "\n")
  end

  def prepare_body
    self.body = self.class.strip_and_unify_newline(self.body)
  end
end
