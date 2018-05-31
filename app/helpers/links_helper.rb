module LinksHelper
  def link_to_delete_helper resource, name
    link_to(
      content_tag(:i, '', class:'fa fa-trash'), 
      resource, 
      method: :delete, 
      data: {
        confirm: "Seguro que desea eliminar a #{name}?", 
        title: 'Eliminando...', 
        commit: 'Eliminar',
        cancel: 'Cancelar'}, 
      class: 'btn btn-danger btn-sm'
    )
  end

  def link_to_logout_helper 
    link_to(
      "#{content_tag(:i, '', class:'fa fa-sign-out')} Cerrar Sesión".html_safe, 
      destroy_user_session_path , 
      method: :delete, 
      data: {
        confirm: '¿Desea salir de la plataforma?', 
        title: 'Cerrando Sesión', 
        commit: 'Salir', 
        cancel: 'No'}
    )
  end

end
