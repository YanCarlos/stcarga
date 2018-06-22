class AddEmployeeToModels < ActiveRecord::Migration
  def change
    add_reference(
      :drivers,
      :employee,
      references: :users
    )
    add_reference(
      :imports,
      :employee,
      references: :users
    )
    add_reference(
      :dispatches,
      :employee,
      references: :users
    )
    add_reference(
      :import_products,
      :employee,
      references: :users
    )
    add_reference(
      :products,
      :employee,
      references: :users
    )
    add_reference(
      :users,
      :employee,
      references: :users
    )
  end
end
