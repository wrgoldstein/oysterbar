class Order < ActiveRecord::Base
  has_and_belongs_to_many :oysters
  has_many :orders_oysters
end
