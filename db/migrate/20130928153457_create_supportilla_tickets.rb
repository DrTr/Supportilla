class CreateSupportillaTickets < ActiveRecord::Migration
  def change
    create_table :supportilla_tickets do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.string :status
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
