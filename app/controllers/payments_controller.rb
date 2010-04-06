class PaymentsController < Restfulie::Server::ActionController::Base

  respond_to :atom,:html

  def create
    @payment = Payment.create(params[:payment])
    render :text => "" , :status => 201, :location => basket_payment_url([@basket, @payment])
  end
  
  def show
    respond_with @payment = Payment.find(params[:id])
  end

end

