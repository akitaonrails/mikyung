class PaymentsController < ApplicationController
  include Restfulie::Server::ActionController::Base

  respond_to :atom,:html, :commerce

  def create
    @payment = Payment.create(params[:payment])
    @payment.basket = Basket.find(params[:basket_id])
    @payment.save
    render :text => "" , :status => 201, :location => basket_payment_url(@payment.basket, @payment)
  end
  
  def show
    respond_with @payment = Payment.find(params[:id])
  end

end

