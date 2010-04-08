class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.decimal :amount, :default => 0.0
      t.string  :name
      t.string  :number
      t.string  :code
      t.string  :expires
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
