class User < ActiveRecord::Base
  NAME_AND_NICK_VALIDATION_CONDITIONS = {
    presence: true,
    format: /\A[a-zA-Z0-9_\-]+\Z/,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 240 },
    username_not_reserved: true
  }

  has_one :resume, class_name: 'UserResume'
  has_many :user_taggings
  has_many :tags, through: :user_taggings, class_name: 'UserTag'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates(:name, NAME_AND_NICK_VALIDATION_CONDITIONS)
  validates(:nick, NAME_AND_NICK_VALIDATION_CONDITIONS)

  validates(:member_number, uniqueness: { allow_nil: true, allow_blank: true } )

  scope :order_by_nick,          -> { order(:nick) }
  scope :recent,                 -> { order(updated_at: :desc) }
  scope :order_by_member_number, -> { order(:member_number) }

  def tag_keyword(keyword)
    UserTag.retrieve(keyword).try(:attach, self)
  end

  def detach(tag)
    user_taggings.find_by(user_tag_id: tag).try(:destroy)
  end
end
