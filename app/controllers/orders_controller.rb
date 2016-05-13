class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(params[:orders].permit(:name, :phone))
    @order.status = 'Pending'
    @order.validate_order_oysters(params[:orders][:oysters])

    if @order.errors.blank?
      if @order.errors.blank? && @order.save
        params[:orders][:oysters].each do |name, count|
          oyster = Oyster.where(name: name).first
          OrdersOyster.create!(order: @order, oyster: oyster, count: count) if !count.blank?
          oyster.recalculate_count!(count)
        end
        redirect_to order_path(activation_code: @order.activation_code.downcase, id: @order.id)
        return
      end
    end
    render 'new'
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
      @orders = Order.where(status: 'Done').order(created_at: :desc).all
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
