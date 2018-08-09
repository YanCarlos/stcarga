class AddCloseForEmployeeToDispatches < ActiveRecord::Migration
  def change
  	add_column :dispatches, :close_for_employees, :boolean
  end
end
