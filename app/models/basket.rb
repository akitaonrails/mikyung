class Basket < ActiveRecord::Base
  
  has_many :selected_items
  
end
