class AddMaxAmountToOysters < ActiveRecord::Migration
  def change
    add_column :oysters, :max, :integer
  end
end
