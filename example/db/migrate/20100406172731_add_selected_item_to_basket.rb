class AddSelectedItemToBasket < ActiveRecord::Migration
  def self.up
    add_column :selected_items, :basket_id, :integer
  end

  def self.down
    remove_column :selected_items, :basket_id
  end
end
