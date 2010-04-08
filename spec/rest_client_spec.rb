require 'spec_helper'
require 'mikyung'
require 'opensearch_mediatype'
require 'commerce_mediatype'

describe Restfulie do

  class SearchProducts
    def execute(entry)
      # should be GET, access
      entry.search.post!("rest")
    end
  end
  
  class PickProduct

    def execute(list)
      
      cheapest = list.entries.inject(list.entries[0]) do |f, s|
        f.price <= s.price ? f : s
      end
      
      # adds the cheapest and the first product
      basket = [{:id => cheapest.id, :quantity => 1}, {:id => list.entries[0].id, :quantity => 1}]
      
      list.basket.post!(basket)
    end
  end
  
  class FinishesOrder
    def execute(basket)
      payment = {:creditcard_number => "4850000000000001", :creditcard_holder => "guilherme silveira", :creditcard_expires => "10/2020", :creditcard_code => "123", :amount => basket.price}
      basket.payment.post!(payment)
    end
  end
  
  class Buy < RelationDrivenObjective
    
    def completed?(resource)
      resource.respond_to?(:status) && resource.status == "paid"
    end
    
    executes FinishesOrder, :when => has_relation?(:payment)
    executes PickProduct, :when => has_relation?(:basket)
    executes SearchProducts, :when => has_relation?(:search)
    
  end

  it "buys some products" do
    Mikyung.new(Buy.new).run('http://localhost:3000/')
  end
  
end