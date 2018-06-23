class Driver < ActiveRecord::Base
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'

  def self.filter param
    Driver.where(
      'lower(name) LIKE :filter or lower(identification) LIKE :filter
        or lower(carriage_plate) LIKE :filter',
      {filter: "#{param}%".downcase}
    )
  end

  before_save do
    set_maker
  end

  after_create do
    create_audit 'creó'
  end

  after_update do
    create_audit 'modificó'
  end

  after_destroy do
    create_audit 'eliminó'
  end

  private
  def set_maker
    self.employee = User.current
  end

  def create_audit action
    audit = Audit.create({
      user_id: User.current.id,
      description: "#{self.employee.name} #{action} al conductor #{self.name} con identificación #{self.identification}. <a href= 'drivers/#{self.id}/edit'><i class='fa fa-eye'></i></a>"
    })
  end
end
