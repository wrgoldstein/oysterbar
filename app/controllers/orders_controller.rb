class OrdersController < ApplicationController
  def new
    Order.new
  end

  def create
    puts 'Create called', params[:orders]
    @order = Order.new(params[:orders].permit(:name, :phone))
    @order.update_attributes!(status: 'Pending')
    params[:orders][:oysters].each do |name, count|
      oyster = Oyster.where(name: name).first
      return unless oyster
      OrdersOyster.create!(order: @order, oyster: oyster, count: count) if !count.blank?
    end

    if @order.save
      redirect_to order_path(activation_code: @order.activation_code, id: @order.id)
    else
      render 'new'
    end
  end

  def show
    @order = Order.where(activation_code: params[:activation_code]).first
    unless @order
      render 'new'
      return
    end
    @oysters = []
    @order.orders_oysters.each do |order_oyster|
      return if order_oyster.count.blank?
      oyster_name = Oyster.find(order_oyster.oyster_id).name
      @oysters << [oyster_name, order_oyster.count]
    end
  end
end
