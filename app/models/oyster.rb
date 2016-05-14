class Oyster < ActiveRecord::Base
  has_and_belongs_to_many :orders

  def recalculate_count!(amount_to_subtract)
    self.count = count - amount_to_subtract.to_i
    save!
  end
end
