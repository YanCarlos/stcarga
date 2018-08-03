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

  validate :validate_date_of_return_at

  after_commit :create_audit, on: [:create, :update, :destroy]

  before_save do
    set_employee
  end


  def self.by_code code
    Container.where('lower(code) LIKE ?', "#{code}%".downcase)
  end

  def self.by_customer customer_id
    Container.where('user_id = ?', customer_id)
  end

  def validate_date_of_return_at
    if self.delivered and self.date_of_return_at.nil?
      errors.add(:date_of_return_at, 'Debe elegir una fecha si desea entregar el contenedor.')
    end
  end

  private
  def set_employee
    self.employee = User.current
  end

  def create_audit
    action_name = if transaction_include_any_action?([:destroy])
                    'eliminó'
                  elsif transaction_include_any_action?([:create])
                    'creó'
                  else
                    'modificó'
                  end
    url = "<a href= 'containers/#{self.id}/edit'><i class='fa fa-eye'></i></a>" unless transaction_include_any_action?([:destroy])
    audit = Audit.create({
      user_id: User.current.id,
      description: "#{self.employee.name} #{action_name} el contenedor #{self.code} del cliente  #{self.user.name}. #{url}"
    })
  end

end
