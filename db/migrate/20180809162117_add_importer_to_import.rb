class AddImporterToImport < ActiveRecord::Migration
  def change
  	add_column :imports, :importer, :string
  	add_column :imports, :description, :string
  end
end
