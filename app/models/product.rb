class Product < ActiveRecord::Base
  has_many :import_products, dependent: :destroy
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'

  def self.by_name name
    Product.where('lower(name) LIKE ?', "#{name}%".downcase)
  end


  before_save do
    set_maker
  end

  private
  def set_maker
    self.employee = User.current
  end
end
