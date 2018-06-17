class CreateDriver < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :identification
      t.string :phone
      t.string :carriage_plate
      t.string :trailer

      t.timestamps
    end
  end
end
