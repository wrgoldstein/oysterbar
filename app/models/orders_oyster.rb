class OrdersOyster < ActiveRecord::Base
  belongs_to :order
  belongs_to :oyster
end
