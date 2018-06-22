class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many(
    :containers,
    dependent: :destroy,
    class_name: 'Container',
    foreign_key: 'user_id'
  )

  has_many(
    :container_maker,
    dependent: :destroy,
    class_name: 'Container',
    foreign_key: 'employee_id'
  )

  has_many(
    :dispatch_maker,
    dependent: :destroy,
    class_name: 'Dispatch',
    foreign_key: 'employee_id'
  )

  has_many(
    :driver_maker,
    dependent: :destroy,
    class_name: 'Driver',
    foreign_key: 'employee_id'
  )

  has_many(
    :import_maker,
    dependent: :destroy,
    class_name: 'Import',
    foreign_key: 'employee_id'
  )

  has_many(
    :product_maker,
    dependent: :destroy,
    class_name: 'Product',
    foreign_key: 'employee_id'
  )

  has_many(
    :inventory_maker,
    dependent: :destroy,
    class_name: 'ImportProduct',
    foreign_key: 'employee_id'
  )

  has_many(
    :user_maker,
    dependent: :destroy,
    class_name: 'User',
    foreign_key: 'employee_id'
  )

  has_many(:imports, dependent: :destroy)

  has_many(:audits, dependent: :destroy)

  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'

  before_validation do
    set_password
    identification_exists?
  end

  validates(:identification,
    length: { minimum: 5, message:  'La cedula debe tener mas de 5 digitos.' },
    numericality: { message: 'La cedula debe ser númerica.' }
  )

  validate :validate_role



  def active_for_authentication?
    super && self.active?
  end

  def be_admin
    self.add_role :admin
  end

  def be_employee
    self.add_role :employee
  end

  def be_customer
    self.add_role :customer
  end

  def self.by_name name
    User.where('lower(name) LIKE ?', "#{name}%".downcase)
  end

  def the_role
    self.roles.first.name.to_sym
  end

  def el_rol
    role = case self.the_role
            when :employee then  'Empleado'
            when :customer then 'Cliente'
            when :admin    then 'Administrador'
           end
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  private
  def defined_roles
    [:admin, :employee , :customer]
  end

  def set_password
    self.password = self.identification
    self.password_confirmation = self.identification
  end

  def validate_role
    my_role = self.the_role
    errors.add(:roles, 'Este rol no esta disponible') unless defined_roles.include? my_role
  end

  def identification_exists?
    found = User.find_by(:identification => self.identification)
    errors.add(:identification, 'Esta identificación ya esta en uso.')if found and found != self
  end

  before_save do
    set_maker
  end

  private
  def set_maker
    self.employee = User.current
  end

end
