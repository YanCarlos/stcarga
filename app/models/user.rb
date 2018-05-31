class User < ActiveRecord::Base
  rolify 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :containers, dependent: :destroy

  before_validation do
    set_password
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

  def self.by_name name
    User.where('lower(name) LIKE ?', "#{name}%".downcase)
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
    my_role = self.roles.first.name.to_sym
    errors.add(:roles, 'Este rol no esta disponible') unless defined_roles.include? my_role 
  end
end
