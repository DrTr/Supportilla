class DeleteSubjectAndStatusFromTicket < ActiveRecord::Migration
  def change
    remove_column :supportilla_tickets, :subject
    remove_column :supportilla_tickets, :status
  end
end
