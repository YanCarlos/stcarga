class AddWasEmailSentToUser < ActiveRecord::Migration
  def change
    add_column :users, :was_email_sent, :boolean
  end
end
