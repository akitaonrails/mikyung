class ItemsController < Restfulie::Server::ActionController::Base

  respond_to :atom, :html
  
  def search
    respond_with @items = Item.find_by_name(Item.new(params[:item]).name)
  end
  
end

