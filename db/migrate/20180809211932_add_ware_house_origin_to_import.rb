class AddWareHouseOriginToImport < ActiveRecord::Migration
  def change
    add_column :imports, :warehose_origin, :string
  end
end
