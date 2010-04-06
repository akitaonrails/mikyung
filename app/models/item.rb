class Item < ActiveRecord::Base

  def value 
    qt * price
  end
  
  def self.find_by_name(name)
    find(:all, :conditions => ["name like :name", {:name => "%#{name}%"}]) || []
  end

end
