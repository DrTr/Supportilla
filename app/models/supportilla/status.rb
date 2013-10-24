module Supportilla
  class Status < ActiveRecord::Base
    attr_accessible :description, :role, :identify
    validates :description, presence: true, length: { maximum: 30 }
    validates :role, presence: true, length: { maximum: 30 }
    validates :identify, presence: true, uniqueness: true,
      length: { maximum: 30 }
    validates :basic, inclusion: { in: [true, false] }
    has_many :tickets
  end
end
