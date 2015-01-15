class UserTag < ActiveRecord::Base
  require 'nkf'

  has_many :user_taggings
  has_many :users, through: :user_taggings

  def self.retrieve(name)
    create(name: name, search_hash: hash_keyword(name))
  end

  def self.normalize_keyword(keyword)
    NKF.nkf('-w -X -Z', keyword.gsub(/[\s　]/, ''))
  end

  def self.hash_keyword(keyword)
    Digest::SHA256.hexdigest(self.normalize_keyword(keyword).downcase)
  end
end
