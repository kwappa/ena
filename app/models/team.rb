class Team < ActiveRecord::Base
  include Renderable
  include Role::Team

  has_many :assignments
  has_many :users, through: :assignments

  validates_presence_of :name

  def active?
    self.disbanded_on.blank?
  end

  def disbanded?
    self.active?.!
  end

  def roles(user)
    self.assignments.where(user_id: user.id).pluck(:role_id).map { |role_id| Role.name(role_id) }.uniq
  end
end
