class UserResumeHistory < ActiveRecord::Base
  def self.record_diff(user_id, old_body, current_body)
    diff =  Diffy::Diff.new(old_body + "\n", current_body + "\n", context: 3, include_diff_info: true).to_s
    create(user_id: user_id, diff: diff)
  end
end
