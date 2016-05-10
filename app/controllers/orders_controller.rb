class OrdersController < ApplicationController
  def new
    Order.new
  end

  def create
    puts 'Create called', params[:orders]
    @order = Order.new
    params[:orders].each do |name, count|
      oyster = Oyster.where(name: name).first
      binding.pry
      return unless oyster
      OrdersOyster.create! order: @order, oyster: oyster, count: count
    end

    if @order.save
      flash[:success] = "New order created"
      render json: @order.attributes.merge(oysters: @order.orders_oysters.map(&:attributes)).as_json
    else
      render 'new'
    end
  end
end
