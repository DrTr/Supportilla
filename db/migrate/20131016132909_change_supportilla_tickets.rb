class ChangeSupportillaTickets < ActiveRecord::Migration
  def change
    change_table :supportilla_tickets do |t|
      t.belongs_to :staff, class_name: Supportilla::Staff
    end
  end
end
