class User < ActiveRecord::Base
  include Authority::User
  include Role::User

  NAME_AND_NICK_VALIDATION_CONDITIONS = {
    presence: true,
    format: /\A[a-zA-Z0-9_\-]+\Z/,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 240 },
    username_not_reserved: { additional_reserved_names: %w[user_tag user_tags team teams] },
  }

  SUSPEND_STATUS = [
    :active,                    # 0
    :suspension,                # 1
    :resignation,               # 2
  ]

  SUSPEND_STATUS_MESSAGE = {
    active:      'Active',
    suspension:  'Suspension',
    resignation: 'Resignation',
  }

  SUSPEND_STATUS_FA_ICON = {
    active:      'user',
    suspension:  'hospital-o',
    resignation: 'unlink',
  }

  has_one :resume, class_name: 'UserResume'
  has_many :user_taggings
  has_many :tags, through: :user_taggings, class_name: 'UserTag'
  has_many :resume_histories, class_name: 'UserResumeHistory'
  has_many :assignments
  has_many :teams, through: :assignments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates(:name, NAME_AND_NICK_VALIDATION_CONDITIONS)
  validates(:nick, NAME_AND_NICK_VALIDATION_CONDITIONS)

  validates(:member_number, uniqueness: { allow_nil: true, allow_blank: true } )

  scope :order_by_nick,          -> { order(:nick) }
  scope :recent,                 -> { order(updated_at: :desc) }
  scope :order_by_member_number, -> { order(:member_number) }

  scope :active,    -> { where(suspend_reason: 0) }
  scope :suspended, -> { where.not(suspend_reason: 0) }

  def tag_keyword(keyword)
    UserTag.retrieve(keyword).try(:attach, self)
  end

  def detach(tag)
    user_taggings.find_by(user_tag_id: tag).try(:destroy)
  end

  def active?
    self.suspend_status == :active
  end

  def suspended?
    active?.!
  end

  def suspend_status
    SUSPEND_STATUS[self.suspend_reason]
  end

  def suspend_status_message
    SUSPEND_STATUS_MESSAGE[self.suspend_status]
  end

  def suspend_status_fa_icon
    SUSPEND_STATUS_FA_ICON[self.suspend_status]
  end
end
