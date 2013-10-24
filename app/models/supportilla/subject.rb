module Supportilla
  class Subject < ActiveRecord::Base
    attr_accessible :description, :activity
    validates :description, presence: true, uniqueness: true,
      length: { maximum: 30 }
    validates :activity, inclusion: { in: [true, false] }
    has_many :tickets, dependent: :destroy
  end
end
