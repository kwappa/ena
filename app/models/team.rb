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
end
