class AddPracticeBooks < ActiveRecord::Migration
  def self.up
    Item.create(:name => "resting in the clouds", :price => 20)
    Item.create(:name => "restfulie in practice", :price => 5)
    Item.create(:name => "your new couch: rest", :price => 200)
  end

  def self.down
    Item.delete_all
  end
end
