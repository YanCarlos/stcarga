class Product < ActiveRecord::Base

  def self.by_name name
    Product.where('lower(name) LIKE ?', "#{name}%".downcase)
  end
end
