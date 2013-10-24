class AddHistoryToSupportillaTickets < ActiveRecord::Migration
  def change
    add_column :supportilla_tickets, :history, :text
  end
end
