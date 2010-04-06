class OrdersController < Restfulie::Server::ActionController::Base

  respond_to :atom, :html

  def index
    respond_with []
    # respond_with @orders = Order.all
  end

  def new
    respond_with @order = Order.new
  end

  def create
    @order = Order.create!
    # redirect_to order_url(order)
    render :text => "" , :status => 201, :location => order_url(@order)
    # respond_with @order, :status => 201, :location => order_url(@order)
    # respond_with @order = Order.create!
  end
  
  def show
    respond_with @order = Order.find(params[:id])
  end

  def destroy
    Order.delete(params[:id])
    redirect_to orders_url
  end

end

