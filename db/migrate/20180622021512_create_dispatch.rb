class CreateDispatch < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.string :code
      t.date :date
      t.references :import, foreign_key: true
      t.string :contact
      t.string :phone_number_1
      t.string :phone_number_2
      t.string :description
      t.string :address
      t.string :city
      
      t.timestamps
    end
  end
end
