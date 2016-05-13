class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    puts 'Create called', params[:orders]
    @order = Order.new(params[:orders].permit(:name, :phone))
    @order.status = 'Pending'
    params[:orders][:oysters].each do |name, count|
      oyster = Oyster.where(name: name).first
      break unless oyster || @order.errors.any?
      if count.to_i > oyster.max
        @order.errors.add(:oops!, "Can't order more than #{oyster.max} of each oyster!")
      else
        OrdersOyster.create!(order: @order, oyster: oyster, count: count) if !count.blank?
      end
    end

    if @order.errors.blank? && @order.save
      @order.send_initial_message
      redirect_to order_path(activation_code: @order.activation_code.downcase, id: @order.id)
    else
      render 'new'
    end
  end

  def show
    @order = Order.where(activation_code: params[:activation_code].downcase).first
    unless @order
      @error = 'Code is invalid.'
      render 'home'
    end
  end

  def index
    if params[:status] == 'Done'
      @status = 'Done'
      @orders = Order.where(status: 'Done').all
    else
      @status = 'Pending'
      @orders = Order.where(status: 'Pending').all
    end
  end

  def done
    @order = Order.find(params[:id])
    @order.update_attributes!(status: 'Done')
    @order.send_ready_message
    redirect_to orders_path(status: 'Pending') # can be smarter here
  end

  def remind
    @order = Order.find(params[:id])
    @order.send_reminder_message
    redirect_to orders_path(status: 'Done') # can be smarter here
  end
end
