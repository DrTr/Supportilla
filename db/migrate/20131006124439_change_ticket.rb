class ChangeTicket < ActiveRecord::Migration
  def change 
    change_table :supportilla_tickets do |t|
      t.belongs_to :status, class_name: Supportilla::Status
      t.belongs_to :subject, class_name: Supportilla::Subject
    end
  end
end
