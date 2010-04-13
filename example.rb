class Search
  
  def execute(resource)
    resource.search('matrix collection')
  end
  
end

class ChooseAProduct
  
  def cheapest(items)
    items.inject(items[0]) do |acc, item|
      acc.price < item.price ? acc : item
    end
  end
  
  def execute(list)
    list.basket.add(cheapest(list.entries))
  end
  
end

class Pay
  
  def execute(basket)
    basket.payment.create(:number => "41850000", :amount => basket.price)
  end
  
end

class Buy
  
  def completed?(resource)
    resource.status == "paid"
  end
  
  def next_step(resource)
    return Pay if resource.respond_to?(:payment)
    return ChooseAProduct if resource.respond_to?(:basket)
    return Search if resource.respond_to?(:search)
    nil # raise "i was unable to achieve my goal"
  end
  
end

def execute(goal, entry)
  actual = Entry.at(entry)
  previous = actual
  
  while(!goal.completed?(actual))
    step = goal.next_step(actual)
    actual = step ? step.execute(actual) : previous
  end
  
  actual
  
end

execute(Buy.new, 'macys.com')
