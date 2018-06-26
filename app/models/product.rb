class Product < ActiveRecord::Base
  has_many :import_products, dependent: :destroy
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'
  after_commit :create_audit, on: [:create, :update, :destroy]

  def self.by_name name
    Product.where('lower(name) LIKE ?', "#{name}%".downcase)
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
    url = "<a href= 'products/#{self.id}/edit'><i class='fa fa-eye'></i></a>" unless transaction_include_any_action?([:destroy])
    audit = Audit.create({
      user_id: User.current.id,
      description: "#{self.employee.name} #{action_name} el producto #{self.name} con referencia #{self.reference}. #{url} "
    })
  end
end
