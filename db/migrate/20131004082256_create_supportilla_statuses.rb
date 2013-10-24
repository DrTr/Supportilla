class CreateSupportillaStatuses < ActiveRecord::Migration
  def change
    create_table :supportilla_statuses do |t|
      t.string :role
      t.string :description

      t.timestamps
    end
  end
end
