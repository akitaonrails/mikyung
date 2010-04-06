class CreateSelectedItems < ActiveRecord::Migration
  def self.up
    create_table :selected_items do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :selected_items
  end
end
