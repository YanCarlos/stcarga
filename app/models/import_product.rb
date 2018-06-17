class ImportProduct < ActiveRecord::Base
  belongs_to :import
  belongs_to :product
  belongs_to :container

  before_save do
    self.total_of_units = self.total_of_packages * self.unit_by_package
    self.gross_weight = self.net_weight * self.total_of_packages
  end

  def self.by_import import_id
    ImportProduct.where('import_id = ?', import_id)
  end

  def self.filter param
    ImportProduct.where(
      'lower(identification) LIKE :filter',  {filter: "#{param}%".downcase}
    )
  end

  def self.by_product_name product_name
    ImportProduct.joins(:product).where('lower(name) like ?', "#{product_name}%".downcase)
  end
end
