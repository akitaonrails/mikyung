require 'spec_helper'

describe Restfulie do
  
  # curl -H "Accept:application/atom+xml" -i http://localhost:3000/orders/1

  # curl -d "<order><name>Caelum Objects Hotel</name></order>" -H "Content-type:application/xml" -H "Accept:application/atom+xml" -i http://localhost:3000/orders
  
  # it "reads" do
  #   order = Restfulie.at('http://localhost:3000/orders/1').accepts('application/atom+xml').get!
  #   order.items.each { |item| puts items }
  # end
  # 
  # it "works" do
  #   order = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
  #   <entry xmlns=\"http://www.w3.org/2005/Atom\">
  #     <title>Order 1</title>
  #     <id>http://localhost:3000/orders/1</id>
  #     <updated>2010-04-03T22:45:47Z</updated>
  #     <link href=\"http://localhost:3000/orders/1\" rel=\"self\"/>
  #   </entry>
  #   "
  #   order = Restfulie.at('http://localhost:3000/orders').as('application/atom+xml').accepts('application/atom+xml').post!(order)
  #   order.items.each { |item| puts items }
  # end
  
  class Buy
    
    def completed?(resource)
      resource.status == "paid"
    end
    
    def next_step(resource)
      if resource.respond_to?("payment")
        FinishesOrder.new
      elsif resource.respond_to?("basket") && !@added
        PickProduct.new
      elsif resource.respond_to?("search")
        SearchProducts.new
      end
    end
    
  end
  
  class SearchProducts
    def execute(entry)
      resource.search("product" => "restfulie in practice")
    end
    def ok(objective)
    end
  end
  
  class PickProduct
    def execute(items)
      cheapest = resource.items.inject(resource.items[0]) do |cheapest, item|
        (cheapest.price <= item.price) ? cheapest : item
      end
      resource.basket << cheapest
    end
    def ok(objective)
      objective.added
    end
  end
  
  class FinishesOrder
    def execute(basket)
      basket.payment << payment
    end
    def ok(objective)
      objective.bought
    end
  end
  
  class RestClient

    # keeps changing from a steady state to another until its goal has been achieved
    def run(goal, uri)
      current = Restfulie.at(uri).get!
      while(!goal.completed?(current))
        step = goal.next_step(current)
        puts "Next step will be #{step}"
        direct_execute(goal, step, current, 3)
      end
    end

    private
    
    def try_to_execute(objective, step, current, max_attempts)
      raise "Unable to proceed when trying to #{step}" if max_attempts == 0

      resource = step.execute(current)
      if resource.response.code != 200
        execute(objective, step, max_attempts - 1)
      else
        step.ok(objective)
        resource
      end
    end

    def direct_execute(objective, step, current, max_attempts)
      step.execute(current)
    end
  end
  
  it "magics" do
    RestClient.new.run(Buy.new, 'http://localhost:3000/')
  end
  
end