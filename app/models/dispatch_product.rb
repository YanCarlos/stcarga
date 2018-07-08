class DispatchProduct < ActiveRecord::Base
  belongs_to :dispatch
  belongs_to :import_product

  def self.by_dispatch dispatch_id
    DispatchProduct.where('dispatch_id = ?', dispatch_id)
  end

  def self.filter dispatch, filter
    case filter[:type]
    when 'identification'
      self.filter_by_identification(dispatch, filter[:text])
    when 'container'
      self.filter_by_container(dispatch, filter[:text])
    else
      self.filter_by_product_name(dispatch, filter[:text])
    end
  end

  def self.filter_by_product_name dispatch, product_name
  	DispatchProduct.where('dispatch_id = ?', dispatch.id).joins("join import_products ip on ip.id = dispatch_products.import_product_id join products p on p.id = ip.product_id").where("lower(p.name) like ?", "#{product_name.downcase}%")
  end

  def self.filter_by_container dispatch, container
  	DispatchProduct.where('dispatch_id = ?', dispatch.id).joins("join import_products ip on ip.id = dispatch_products.import_product_id join containers c on c.id = ip.container_id").where("lower(c.code) like ?", "#{container.downcase}%")
  end
end
