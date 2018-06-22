class CreateAudit < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.references :user, index: true, foreign_key: true
      t.string :description
      t.timestamps
    end
  end
end
