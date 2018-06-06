class AddEmployeeToContainer < ActiveRecord::Migration
  def change
    add_reference(
      :containers,
      :employee,
      references: :users
    )
  end
end
