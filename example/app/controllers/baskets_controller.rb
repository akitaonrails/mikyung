class BasketsController < ApplicationController
  include Restfulie::Server::ActionController::Base
  
  respond_to :atom, :html, :commerce
  
  def create
    b = Basket.new
    items.each do |item|
      item = SelectedItem.create(:item => Item.find(item["id"].to_i), :quantity => item["quantity"].to_i)
      b.selected_items << item
    end
    b.save
    render :text => "" , :status => 201, :location => basket_url(b)
  end
  
  def items
    found = params[:feed][:entry]
    if found.kind_of? Array
      found
    else
      [found]
    end
  end
  
  def show
    respond_with @basket = Basket.find(params[:id])
  end
  
end
