class CreateImport < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :code
      t.date :date
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
