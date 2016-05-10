class CreateOrderOysters < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :phone
      t.timestamps null: false
    end

    create_table :oysters do |t|
      t.string :name
      t.integer :count
      t.timestamps null: false
    end

    create_table :orders_oysters, id: false do |t|
      t.belongs_to :order, index: true
      t.belongs_to :oyster, index: true
      t.integer :count
    end
  end
end