require 'spec_helper'
require 'mikyung'
require 'opensearch_mediatype'
require 'commerce_mediatype'

# module Restfulie::Common::Representation
#   # Implements the interface for unmarshal Atom media type responses (application/atom+xml) to ruby objects instantiated by rAtom library.
#   #
#   # Furthermore, this class extends rAtom behavior to enable client users to easily access link relationships.
#   class Atom
# 
#     def verb_for(rel)
#       {"search" => :post, "basket" => :post, "payment" => :post}[rel]
#     end
# 
#     def self.to_hash(string)
#       Hash.from_xml(string).with_indifferent_access
#     end
#   end
# 
# end

module Restfulie::Client::HTTP#:nodoc:

  # Gives to Atom::Link capabilities to fetch related resources.
  module LinkRequestBuilder
    # def access!(object)
    #   if self.respond_to?(:original_media_type)
    #     verb = Restfulie::Client::HTTP::RequestMarshaller.content_type_for(self.original_media_type).verb_for(self.rel)
    #   end
    #   if verb.nil?
    #     # implement future guessing here
    #     verb = :get
    #   end
    #   # self.type ==> expected media type
    #   self.send("#{verb.to_s}!".to_s, object)
    # end
    
  end
end

describe Restfulie do

  class SearchProducts
    def execute(entry)
      # should be GET
      # should be search.access
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