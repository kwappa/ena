class User < ActiveRecord::Base
  NAME_AND_NICK_VALIDATION_CONDITIONS = {
    presence: true,
    format: /\A[a-zA-Z0-9_\-]+\Z/,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 240 },
    username_not_reserved: { additional_reserved_names: %w[foo bar] },
  }

  SUSPEND_REASON = {
    active:      0,
    suspension:  1,
    resignation: 2,
  }

  has_one :resume, class_name: 'UserResume'
  has_many :user_taggings
  has_many :tags, through: :user_taggings, class_name: 'UserTag'
  has_many :resume_histories, class_name: 'UserResumeHistory'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates(:name, NAME_AND_NICK_VALIDATION_CONDITIONS)
  validates(:nick, NAME_AND_NICK_VALIDATION_CONDITIONS)

  validates(:member_number, uniqueness: { allow_nil: true, allow_blank: true } )

  scope :order_by_nick,          -> { order(:nick) }
  scope :recent,                 -> { order(updated_at: :desc) }
  scope :order_by_member_number, -> { order(:member_number) }

  scope :active,    -> { where(suspend_reason: SUSPEND_REASON[:active]) }
  scope :suspended, -> { where.not(suspend_reason: SUSPEND_REASON[:active]) }

  def tag_keyword(keyword)
    UserTag.retrieve(keyword).try(:attach, self)
  end

  def detach(tag)
    user_taggings.find_by(user_tag_id: tag).try(:destroy)
  end

  def active?
    self.suspend_reason == SUSPEND_REASON[:active]
  end

  def suspended?
    active?.!
  end
end
