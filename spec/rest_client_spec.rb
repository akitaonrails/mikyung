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
      resource.respond_to?(:status) && resource.status == "paid"
    end
    
    def next_step(resource)
      if resource.respond_to?("payment")
        FinishesOrder.new
      elsif resource.respond_to?("basket") && !@added
        PickProduct.new
      elsif resource.respond_to?("search")
        SearchProducts.new
      else
        puts "Resource links are: "
        puts resource.links
        raise "Unable to find the next step for #{resource} with #{resource.response.code}, #{resource.response.body}"
      end
    end
    
  end
  
  class SearchProducts
    def execute(entry)
      entry.search.as('application/xml').post!("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <item>
        <name>rest</name>
      </item>")
    end
    def ok(objective)
    end
  end
  
  class PickProduct
    
    def price(item)
      item["http://localhost:3000/items", "price"][0].to_d
    end
    
    def execute(list)
      cheapest = list.entries.inject(list.entries[0]) do |cheapest, item|
        (price(cheapest) <= price(item)) ? cheapest : item
      end
      list.basket.as("application/atom+xml").post!(cheapest.to_xml)
      # should be list.basket.post!(cheapest)
      # should be list.basket << cheapest
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
    
    def initialize(goal)
      @goal = goal
    end

    # keeps changing from a steady state to another until its goal has been achieved
    def run(uri)
      
      current = Restfulie.at(uri).get!
      puts current.response.body
      
      while(!@goal.completed?(current))
        step = @goal.next_step(current)
        puts "Next step will be #{step}"
        current = try_to_execute(step, current, 3)
      end
      
    end

    private
    
    def try_to_execute(step, current, max_attempts)
      raise "Unable to proceed when trying to #{step}" if max_attempts == 0

      resource = step.execute(current)
      if resource.response.code != 200
        try_to_execute(step, max_attempts - 1)
      else
        puts resource.response.body
        step.ok(@goal)
        resource
      end
    end

    def direct_execute(step, current, max_attempts)
      step.execute(current)
    end
  end
  
  it "magics" do
    RestClient.new(Buy.new).run('http://localhost:3000/')
  end
  
end