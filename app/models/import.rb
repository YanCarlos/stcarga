class Import < ActiveRecord::Base
  belongs_to :user

  before_validation do
    code_exists?
  end

  def self.by_code code
    Import.where('lower(code) LIKE ?', "#{code}%".downcase)
  end

  def self.by_customer customer_id
    Import.where('user_id = ?', customer_id)
  end

  private
  def code_exists?
    found = Import.find_by(:code => self.code)
    errors.add(:code, 'Este codigo ya esta registrado.')if found and found != self
  end
end
