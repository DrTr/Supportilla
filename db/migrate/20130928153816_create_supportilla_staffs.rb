class CreateSupportillaStaffs < ActiveRecord::Migration
  def change
    create_table :supportilla_staffs do |t|
      t.string :username
      t.string :password_digest
      t.boolean :admin

      t.timestamps
    end
  end
end
