class RelatePaymentToBasket < ActiveRecord::Migration
  def self.up
    add_column :payments, :basket_id, :integer
  end

  def self.down
    remove_column :payments, :basket_id
  end
end
