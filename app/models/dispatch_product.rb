class DispatchProduct < ActiveRecord::Base
  belongs_to :dispatchs
  belongs_to :import_products
end
