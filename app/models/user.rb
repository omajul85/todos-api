class User < ApplicationRecord
  # encrypt password via bcrypt gem
  has_secure_password

  has_many :todos,
           foreign_key: 'created_by',
           dependent: :destroy

   validates :name, :email, :password_digest, presence: true
   validates :email, uniqueness: true
end
