class BasketsController < ApplicationController
  
  respond_to :atom, :html
  
  def create
    b = Basket.new
    items.each do |item|
      item = SelectedItem.create(:item => Item.find(item["id"].to_i))
      b.selected_items << item
    end
    b.save
    render :text => "" , :status => 201, :location => basket_url(b)
  end
  
  def items
    found = params[:basket][:item]
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
