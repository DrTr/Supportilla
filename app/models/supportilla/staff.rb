module Supportilla
  class Staff < ActiveRecord::Base
    attr_accessible :admin, :password, :password_confirmation, :username
    validates :username, presence: true, uniqueness: true,
      length: { maximum: 15 }
    validates :password, presence: true
    validates :password_confirmation, presence: true
    validates :admin, inclusion: { in: [true, false] }
    has_secure_password
    has_many :tickets
    default_scope -> { order('username ASC') }
  end
end
