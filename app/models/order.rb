class Order < ActiveRecord::Base
  require 'random_word_generator'
  before_create :set_activation_code

  has_and_belongs_to_many :oysters
  has_many :orders_oysters

  def set_activation_code
    self.activation_code = nil
    while self.activation_code == nil
      word = RandomWordGenerator.word
      if Order.where(activation_code: word).first
        break
      else
        self.activation_code = word
      end
    end
  end

  def formatted
    attributes.merge(oysters: formatted_oysters)
  end

  def formatted_oysters
    orders_oysters.map do |order_oyster|
      return if order_oyster.count.blank?
      oyster_name = Oyster.find(order_oyster.oyster_id).name
      [oyster_name, order_oyster.count]
    end
  end
end
