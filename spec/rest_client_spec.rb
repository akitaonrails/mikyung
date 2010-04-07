require 'spec_helper'

describe Restfulie do

  class Buy
    
    def completed?(resource)
      resource.respond_to?(:status) && resource.status == "paid"
    end
    
    def next_step(resource)
      options = [ ["payment", FinishesOrder], ["basket", PickProduct], ["search", SearchProducts]]
      step = options.find do |k|
        resource.respond_to?(k.first)
      end
      step ? step.last : nil
    end
    
  end
  
  class SearchProducts
    def execute(entry)
      
      # automatic INSTANCE TO ATOM...
      # TODO 2 sera que funcionaria OPEN SEARCH???
      
      entry.search.as('application/xml').post!("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <item>
        <name>rest</name>
      </item>")
    end
  end
  
  class PickProduct
    
    def price(item)
      item.price
    end
    
    def execute(list)
      cheapest = list.entries.inject(list.entries[0]) do |f, s|
        f.price <= s.price ? f : s
      end
      
      # TODO atom ja ajudaria
      list.basket.as("application/xml").post!("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <basket>
        <item><id>#{cheapest.id}</id><quantity>2</quantity></item>
        <item><id>#{cheapest.id}</id><quantity>1</quantity></item>
      </basket>")
      # should be list.basket.post!(cheapest)
      # should be list.basket << cheapest
    end
  end
  
  class FinishesOrder
    def execute(basket)
      # FUNCIONAR ESSE PAYMENT
      basket.payment.as("application/xml").post!("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <payment>
      ...
      </payment>")
      # should be basket.payment.post!(payment)
      # should be basket.payment << payment
    end
  end
  
  class RestClient
    
    def initialize(goal)
      @goal = goal
    end

    # keeps changing from a steady state to another until its goal has been achieved
    def run(uri)
      
      current = Restfulie.at(uri).get!
      # puts current.response.body
      
      while(!@goal.completed?(current))
        step = @goal.next_step(current)
        raise "No step was found for #{current} with links #{current.links}" unless step
        # puts "Next step will be #{step}"
        current = try_to_execute(step.new, current, 3)
      end
      
    end

    private
    
    def try_to_execute(step, current, max_attempts)
      raise "Unable to proceed when trying to #{step}" if max_attempts == 0

      resource = step.execute(current)
      if resource.response.code != 200
        try_to_execute(step, max_attempts - 1)
      else
        # puts resource.response.body
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