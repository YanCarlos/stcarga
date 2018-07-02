class DispatchProduct < ActiveRecord::Base
  belongs_to :dispatch
  belongs_to :import_product
end
