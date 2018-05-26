class AddParamsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :active, :boolean
    add_column :users, :identification, :string
    add_column :users, :contact_email, :string
    add_column :users, :contact_name, :string
    add_column :users, :contact_phone, :string
  end
end
