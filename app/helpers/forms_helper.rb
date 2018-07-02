module FormsHelper
  def inventory_filter
    [
     ['Filtro por identificación', 'identification'],
     ['Filtro por producto', 'product'],
     ['Filtro por contenedor', 'container']
    ]
  end

  def dispatches_filter
    [
      ['Filtro por codigo', 'code'],
      ['Filtro por ciudad', 'city'],
      ['Filtro por contacto', 'contact']
    ]
  end

  def is_tab_active? param
    return 'active' if session[:last_stcarga_action] == param
  end

  def product_name product
    "#{product.name} [#{product.reference}]"
  end


  def products_in_stock arg
    registered_in_import = ImportProduct.where('id = ?',arg[:inventory_id]).sum(:total_of_packages)
    registered_in_dispatchs = DispatchProduct.where('import_product_id = ?', arg[:inventory_id]).sum(:total_of_packages)
    binding.pry
    return registered_in_import - registered_in_dispatchs
    # Dispatch.where('import_id = ?', arg[:import_id]).each do |dispatch|
    #   DispatchProduct.where('')
    # end
  end

end
