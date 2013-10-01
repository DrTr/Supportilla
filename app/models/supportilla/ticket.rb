module Supportilla
  class Ticket < ActiveRecord::Base
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    attr_accessible :answer, :email, :name, :question
    attr_accessible :refer, :status, :subject
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
    validates :subject, presence: true
    validates :question, presence: true
    validates :name, presence: true
    before_create :form_ticket
    
    def to_param
    "#{id_hashed.parameterize}"
    end
    
    private
    def form_ticket
      self.status = "Waiting for Staff Response"
      today_tickets = Ticket.where("DATE(created_at) = DATE(?)", Time.now)
      index = ("aaa".."zzz").to_a[today_tickets.count]
      self.refer = index + "-" + Time.now.strftime("%d%m%y")
      self.id_hashed =  Digest::MD5.hexdigest(self.refer)
    end
  end
end
