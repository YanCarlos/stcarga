class AddDriverToDispatch < ActiveRecord::Migration
  def change
  	add_reference(
      :dispatches,
      :driver,
      references: :drivers
    )
  end
end
