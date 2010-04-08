class AddSelectedItemItem < ActiveRecord::Migration
  def self.up
    add_column :selected_items, :item_id, :integer
  end

  def self.down
    remove_column :selected_items, :item_id
  end
end
