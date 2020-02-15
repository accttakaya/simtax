class CreateFunctions < ActiveRecord::Migration[5.2]
  def change
    create_table :functions do |t|

      t.timestamps
    end
  end
end
