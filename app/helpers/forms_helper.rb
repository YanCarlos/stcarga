module FormsHelper
  def inventory_filter
    [
     ['Filtro por producto', 'product'],
     ['Filtro por contenedor', 'container']
    ]
  end

  def dispatches_filter
    [
      ['Filtro por ciudad', 'city'],
    ]
  end

  def imports_filter
    [
      ['Filtro por importación', 'import'],
      ['Filtro por cliente', 'customer']
    ]
  end

  def is_tab_active? param
    return 'active' if session[:last_stcarga_action] == param
  end

  def product_name product
    "#{product.name} (#{product.reference})"
  end

  def product_name_for_dispatch_product import_product
    products_in_stock = products_in_stock import_product.id
    "#{import_product.product.name} (#{import_product.product.reference}) [#{import_product.total_of_packages} x #{import_product.unit_by_package}]  [#{import_product.container.code}]"
  end

  def products_in_stock import_product_id
    registered_in_import = ImportProduct.where('id = ?', import_product_id).sum(:total_of_packages)
    registered_in_dispatchs = DispatchProduct.where('import_product_id = ?', import_product_id).sum(:total_of_packages)
    return registered_in_import - registered_in_dispatchs
  end

  def all_product_with_stock dispatch
    dispatch.import.import_products.select{ |ip| products_in_stock(ip) > 0}
  end

  def total_packages_in_inventory import
    total = 0
    import.import_products.select{ |ip| products_in_stock(ip) > 0}.each do |product|
      total += products_in_stock(product)
    end
    return total
  end

end
