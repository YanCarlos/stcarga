class Container < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'
  has_many :import_products, dependent: :destroy

  validates(
    :user_id,
    presence: {message: 'El contenedor debe ir asociado a un cliente.'}
  )
  validates(
    :code,
    presence: { message: 'El codigo del contenedor es obligatorio.' }
  )

  before_save do
    set_employee
  end



  def self.by_code code
    Container.where('lower(code) LIKE ?', "#{code}%".downcase)
  end

  def self.by_customer customer_id
    Container.where('user_id = ?', customer_id)
  end

  private
  def set_employee
    self.employee = User.current
  end
end
