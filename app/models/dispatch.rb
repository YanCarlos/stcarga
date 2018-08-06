class Dispatch < ActiveRecord::Base
  belongs_to :import
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'
  belongs_to :driver
  after_commit :create_audit, on: [:create, :update, :destroy]
  has_many :dispatch_products, dependent: :destroy
  before_save :set_code


  def set_code
    self.code = self.import.dispatches.count + 1
  end

  def self.filter filter
    case filter[:type]
    when 'code'
      self.filter_by_code(filter[:text])
    when 'contact'
      self.filter_by_contact(filter[:text])
    when 'date'
      self.filter_by_date(filter[:date])
    else
      self.filter_by_city(filter[:text])
    end
  end

  def self.filter_by_code param
    Dispatch.where('lower(code) like ?', "#{param}%".downcase)
  end

  def self.filter_by_contact param
    Dispatch.where('lower(contact) like ?', "#{param}%".downcase)
  end

  def self.filter_by_date param
    Dispatch.where('date is ?', param)
  end

  def self.filter_by_city param
    Dispatch.where('lower(city) like ?', "#{param}%".downcase)
  end

  def self.by_import import_id
    Dispatch.where('import_id = ?', import_id)
  end

  before_save do
    set_maker
  end

  private
  def set_maker
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
    url = "<a href= 'dispatchs/#{self.id}/edit'><i class='fa fa-eye'></i></a>" unless transaction_include_any_action?([:destroy])
    audit = Audit.create({
      user_id: User.current.id,
      description: "#{self.employee.name} #{action_name} el despacho #{self.code} del cliente  #{self.import.user.name}. #{url}"
    })
  end
end
