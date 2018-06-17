class Product < ActiveRecord::Base
  has_many :import_products, dependent: :destroy

  def self.by_name name
    Product.where('lower(name) LIKE ?', "#{name}%".downcase)
  end
end
