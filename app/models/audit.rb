class Audit < ActiveRecord::Base
  belongs_to :user

  def self.by_employee filter
    Audit.where('user_id = ?' , filter['employee'])
  end
end
