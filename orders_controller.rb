class OrdersController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]

   def index
      @orders = current_user.customer.orders.order(created_at: :desc)
    end
    def new
      @order = Order.new
      @customer = current_user.customer || current_user.build_customer
      @provinces = Province.all.map { |province| [province.name, province.id] }
      if @customer.address.present?
        @order.address = @customer.address
        @order.province = @customer.province
      end
      
      cart.each do |item|
        @order.order_items.build(product: item[:product], quantity: item[:quantity], price: item[:product].price)
      end
    end

  
    def create
      @customer = current_user.customer || current_user.build_customer
      customer_update_params = {
        address: order_params[:address],
        province_id: order_params[:province_id]
      }
      @customer.assign_attributes(customer_update_params)
  
      @order = @customer.orders.build(order_params)
      cart.each do |item|
        @order.order_items.build(product: item[:product], quantity: item[:quantity], price: item[:product].price)
      end
    
    
      if @customer.save && @order.save
        begin
          payment_intent = create_stripe_charge(@order.calculate_total )
         
          @order.update(payment_id: payment_intent.id)
          @order.update(status: :paid)
          session[:cart].clear
  
          flash[:success] = "Order confirmed."
          redirect_to orders_path
        rescue Stripe::StripeError => e
          flash[:error] = e.message
          render :new, status: :unprocessable_entity
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
    def order_params
      params.require(:order).permit(:subtotal, :gst, :pst, :hst, :total, :address, :province_id, order_items_attributes: [:product_id, :quantity, :price])
    end  
  
    def customer_params
      params.require(:customer).permit(:name, :email, :address, :province_id)
    end    


    def create_stripe_charge(amount)
      amount_in_cents = (amount * 100).round
      Stripe::PaymentIntent.create({
        amount: amount_in_cents,
        currency: 'usd',
        description: 'Example charge',
      })
    end
end
  
