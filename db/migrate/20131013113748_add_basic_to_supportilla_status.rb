class AddBasicToSupportillaStatus < ActiveRecord::Migration
  def change
    add_column :supportilla_statuses, :basic, :boolean
  end
end
