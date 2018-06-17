class CreateImportProducts < ActiveRecord::Migration
  def change
    create_table :import_products do |t|
      t.references :import, foreign_key: true
      t.references :product, foreign_key: true
      t.string :identification
      t.references :container, foreign_key: true
      t.decimal :total_of_packages
      t.decimal :unit_by_package
      t.decimal :total_of_units
      t.decimal :net_weight
      t.decimal :gross_weight

      t.timestamps
    end
  end
end
