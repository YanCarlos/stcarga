class Container < ActiveRecord::Base
  belongs_to :user
  validates( 
    :code, 
    presence: { message: 'El codigo del contenedor es obligatorio.' }
  )
end
