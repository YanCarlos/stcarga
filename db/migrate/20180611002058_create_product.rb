class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :reference
      t.string :description
      t.timestamps
    end
  end
end
