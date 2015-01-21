class UserResumeHistory < ActiveRecord::Base
  include Renderable

  belongs_to :user

  def self.record_diff(user_id, old_body, current_body)
    diff =  Diffy::Diff.new(old_body + "\n", current_body + "\n", context: 3, include_diff_info: true).to_s
    create(user_id: user_id, diff: diff)
  end

  def quoted_diff
    <<-EOD
```diff
#{self.diff}
```
    EOD
  end
end
