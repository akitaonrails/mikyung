class AddSelectedItemQuantity < ActiveRecord::Migration
  def self.up
    add_column :selected_items, :quantity, :integer
    SelectedItem.all.each do |s|
      s.quantity = 1
      s.save
    end
  end

  def self.down
    remove_column :selected_items, :quantity
  end
end
