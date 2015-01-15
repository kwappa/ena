class UserTag < ActiveRecord::Base
  require 'nkf'

  has_many :user_taggings
  has_many :users, through: :user_taggings

  def self.normalize_keyword(keyword)
    NKF.nkf('-w -X -Z', keyword.gsub(/[\s　]/, ''))
  end
end
