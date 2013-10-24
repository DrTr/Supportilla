class AddIdentifyToStatus < ActiveRecord::Migration
  def change
    add_column :supportilla_statuses, :identify, :string
  end
end
