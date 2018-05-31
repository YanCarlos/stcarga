class CreateContainer < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.string :code
      t.date :date_of_return_at
      t.date :deadline_to_return_at
      t.date :date_of_entry_to_warehose_at
      t.date :start_of_debt_at
      t.boolean :delivered
      t.references :user, index: true, foreign_key: true
      
      t.timestamps
    end
  end
end
