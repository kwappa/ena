class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates(:name,
            presence: true,
            format: /\A[a-zA-Z0-9_\-]+\Z/,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 240 },
            username_not_reserved: true
           )
end
