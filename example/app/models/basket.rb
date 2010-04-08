class Basket < ActiveRecord::Base
  
  has_many :selected_items
  
  def cost
    selected_items.inject(0) do |partial, selected_item|
      partial + selected_item.item.price
    end
  end
  
end
