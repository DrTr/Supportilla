module Supportilla
  class Ticket < ActiveRecord::Base
    
    class AbsenceValidator < ActiveModel::EachValidator                                                                                                                                                         
      def validate_each(record, attribute, value)                          
        unless record.send(attribute).blank?
          record.errors[attribute] << (options[:message] || 'must be blank') 
        end
      end                                                                           
    end   
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_REFER_REGEX = /\A[a-z]{3}-\d{6}\z/
    
    attr_accessible :answer, :email, :name, :question, :status_id, :subject_id
    attr_accessible :status, :subject
    
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
      length: { maximum: 30 }
    validates :subject, presence: true
    validates :status, presence: true, on: :update
    validates :question, presence: true
    validates :name, presence: true, length: { maximum: 30 }
    validates :answer, absence: true, on: :create
    validates :staff, absence: true, on: :create
    validates :refer, presence: true, format: { with: VALID_REFER_REGEX },
      on: :update
      
    before_create :form_ticket, :add_savepoint
    before_update :add_savepoint
    
    belongs_to :subject
    belongs_to :status
    belongs_to :staff
    
    default_scope -> { order('created_at ASC') }
    scope :search, ->(search) do 
      ids = Subject.where("description LIKE ?", search).pluck(:id)
      where("name LIKE ? or refer LIKE ? or subject_id in (?)",
        search, search, ids)
    end
    scope :next, ->(ticket) { where("created_at > ?", ticket.created_at) }
    scope :prev, ->(ticket) { where("created_at < ?", ticket.created_at) }
    
    def to_param
    "#{id_hashed.parameterize}"
    end
    
    def add_savepoint
      self.history ||= ""
      titles = ["When", "Staff", "Status", "Question", "Answer"]
      data = [Time.now.to_s, staff ? staff.username : "absent", 
        status.description, question, answer]
      titles.zip(data).each do |row|
        self.history += (row[0] + ": " + (row[1] || "absent") + "<br>") 
      end
      self.history += "<br>"
    end
    
    private
    def form_ticket
      self.status = Status.find_by_identify("unassigned")
      today_tickets = Ticket.where("DATE(created_at) = DATE(?)", Time.now)
      index = ("aaa".."zzz").to_a[today_tickets.count]
      self.refer = index + "-" + Time.now.strftime("%d%m%y")
      self.id_hashed =  Digest::MD5.hexdigest(self.refer)
    end
  end
end
