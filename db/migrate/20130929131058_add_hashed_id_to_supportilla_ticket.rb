class AddHashedIdToSupportillaTicket < ActiveRecord::Migration
  def change
    add_column :supportilla_tickets, :id_hashed, :string
  end
end
