class AddReferToTickets < ActiveRecord::Migration
  def change
    add_column :supportilla_tickets, :refer, :string
  end
end
