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

  def self.filter filter
    case filter[:type]
    when 'identification'
      self.filter_by_identification(filter[:text])
    when 'container'
      self.filter_by_container(filter[:text])
    else
      self.filter_by_product_name(filter[:text])
    end
  end

  def self.filter_by_product_name product_name
    ImportProduct.joins(:product).where('lower(name) like ?', "#{product_name}%".downcase)
  end

  def self.filter_by_container container
    ImportProduct.joins(:container).where('lower(code) like ?', "#{container}%".downcase)
  end

  def self.filter_by_identification identification
    ImportProduct.where(
      'lower(identification) LIKE :filter',  {filter: "#{identification}%".downcase}
    )
  end
end
