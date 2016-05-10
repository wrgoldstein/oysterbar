class AddActivationCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :activation_code, :string
  end
end
