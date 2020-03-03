class RemovenotificationAllowedFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :notification_allowed, :boolean
  end
end
