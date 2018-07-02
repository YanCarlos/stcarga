class CreateDispatchProduct < ActiveRecord::Migration
  def change
    create_table :dispatch_products do |t|
      t.references :dispatch, index: true, foreign_key: true
      t.references :import_product, index: true, foreign_key: true
      t.decimal :total_of_packages
      t.timestamps
    end
  end
end
