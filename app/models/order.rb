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
end
