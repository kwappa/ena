class UserTag < ActiveRecord::Base
  require 'nkf'

  has_many :user_taggings
  has_many :users, through: :user_taggings

  def self.retrieve(name)
    keyword = normalize_keyword(name)
    return nil if keyword.blank?
    create_with(name: keyword).find_or_create_by(search_hash: hash_keyword(name))
  end

  def self.normalize_keyword(keyword)
    NKF.nkf('-w -X -Z', keyword.gsub(/[\s　]/, ''))
  end

  def self.hash_keyword(keyword)
    Digest::SHA256.hexdigest(self.normalize_keyword(keyword).downcase)
  end

  def attach(user)
    unless (user.tags.include?(self))
      UserTagging.create(user_id: user.id, user_tag_id: self.id)
    end
    self
  end
end
