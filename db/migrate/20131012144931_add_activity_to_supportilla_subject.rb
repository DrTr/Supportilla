class AddActivityToSupportillaSubject < ActiveRecord::Migration
  def change
    add_column :supportilla_subjects, :activity, :boolean
  end
end
