class CreateSupportillaSubjects < ActiveRecord::Migration
  def change
    create_table :supportilla_subjects do |t|
      t.string :description

      t.timestamps
    end
  end
end
