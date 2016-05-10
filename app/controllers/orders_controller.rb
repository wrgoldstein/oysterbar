class OrdersController < ApplicationController
  def new
    Order.new
  end

  def create
    puts 'Create called', params[:orders]
    @order = Order.new(params[:orders].permit(:name, :phone))
    params[:orders][:oysters].each do |name, count|
      oyster = Oyster.where(name: name).first
      return unless oyster
      OrdersOyster.create!(order: @order, oyster: oyster, count: count) if !count.blank?
    end

    if @order.save
      flash[:success] = "New order created"
      render json: @order.attributes.merge(oysters: @order.orders_oysters.map(&:attributes)).as_json
    else
      render 'new'
    end
  end

  def show
    @order = Order.where(activation_code: params[:activation_code]).first
  end
end
