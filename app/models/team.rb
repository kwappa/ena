class Team < ActiveRecord::Base
  include Renderable

  validates_presence_of :name

  def active?
    self.disbanded_on.blank?
  end

  def disbanded?
    self.active?.!
  end
end
