class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  scope :active, -> (since = Date.today) do
    where(arel_table[:assigned_on].lteq(since)).
    where(withdrawn_on: nil)
  end

  def role
    Role.name(self.role_id)
  end
end
