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


end
