class ImportProduct < ActiveRecord::Base
  belongs_to :import
  belongs_to :product
  belongs_to :container
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'
  after_commit :create_audit, on: [:create, :update, :destroy]
  has_many :dispatch_products, dependent: :destroy

  before_save do
    self.total_of_units = self.total_of_packages * self.unit_by_package
    self.gross_weight = self.net_weight * self.total_of_packages
    set_maker
  end

  def self.by_import import_id
    ImportProduct.where('import_id = ?', import_id)
  end

  def self.filter filter
    case filter[:type]
    when 'identification'
      self.filter_by_identification(filter[:text])
    when 'container'
      self.filter_by_container(filter[:text])
    else
      self.filter_by_product_name(filter[:text])
    end
  end

  def self.filter_by_product_name product_name
    ImportProduct.joins(:product).where('lower(name) like ?', "#{product_name}%".downcase)
  end

  def self.filter_by_container container
    ImportProduct.joins(:container).where('lower(code) like ?', "#{container}%".downcase)
  end

  def self.filter_by_identification identification
    ImportProduct.where(
      'lower(identification) LIKE :filter',  {filter: "#{identification}%".downcase}
    )
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
    url = "<a href= 'inventories/#{self.id}/edit'><i class='fa fa-eye'></i></a>" unless transaction_include_any_action?([:destroy])
    audit = Audit.create({
      user_id: User.current.id,
      description: "#{self.employee.name} #{action_name} el producto #{self.product.name}[#{self.product.reference}] de la importación #{self.import.code} del cliente  #{self.import.user.name}. #{url}"
    })
  end
end
