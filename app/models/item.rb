class Item < ActiveRecord::Base
  belongs_to :order

  def value 
    qt * price
  end
  
  def self.find_by_name(name)
    find(:all, :conditions => ["name like :name", {:name => "%#{name}%"}]) || []
  end

end
