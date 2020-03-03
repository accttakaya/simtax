class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :acct, :boolean, default: false, null: false
  end
end
