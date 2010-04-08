# ISSUE 1 : allow get with content because we are not sending it, but request parametering it

require 'spec_helper'
require 'mikyung'
require 'opensearch'

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
# 
# 
# 

# module Restfulie::Common::Representation
#   # Implements the interface for unmarshal Atom media type responses (application/atom+xml) to ruby objects instantiated by rAtom library.
#   #
#   # Furthermore, this class extends rAtom behavior to enable client users to easily access link relationships.
#   class OpenSearch
# 
#     def marshal(object)
#       definition = Restfulie.at(self.href).get!
#       definition.Url
#       uri_nova = definition.Url.substitui_baseado_em(object)
#       devolve nil ==> nao poste nada!
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
    
    # def do_conneg_and_choose_representation(method, path, *args)
    #   Restfulie::Client::HTTP::RequestMarshaller.content_type_for(media_type_for_myself)
    # end
    # 
    # def media_type_for_myself
    #   target_type = accepts_ja_sobrescrevi?
    #   target_type ||= self.respond_to?(type)
    #   target_type ||= chuta
    #   target_type
    # end
    
  end
end

describe Restfulie do

  class SearchProducts
    def execute(entry)
      # entry.search.access!("name" => "rest")
      entry.search.post!("rest")
    end
  end
  
  class PickProduct

    def execute(list)
      cheapest = list.entries.inject(list.entries[0]) do |f, s|
        f.price <= s.price ? f : s
      end
      # post ==> faz um OPTIONS, pega o accept e tenta
      
      # class CommerceMediaType
      #   def marshall(rel, obj, verb)
      #     if(rel=="basket")
      #       content = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<basket>"
      #       obj.each do |k, v|
      #         content << "<item><id>#{k.id}</id><quantity>#{v}</quantity></item>"
      #       end
      #       content << "</basket>"
      #       content
      #     end
      #   end
      #   def unmarshall(rel??, content, verb)
      #   end
      # end
      # Restfulie::Client::Representation.register("application/atom+xml+basket", CommerceMediaType)
      
      
      
      
      list.basket.as("application/xml").post!("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <basket>
        <item><id>#{cheapest.id}</id><quantity>2</quantity></item>
        <item><id>#{cheapest.id}</id><quantity>1</quantity></item>
      </basket>")
      
      
      # should be
      # list.basket.post!(cheapest)
      # should be
      # list.basket << cheapest
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
  
  class Buy < RelationDrivenObjective
    
    def completed?(resource)
      resource.respond_to?(:status) && resource.status == "paid"
    end
    
    # config do |resource|
      executes FinishesOrder, :when => has_relation?(:payment)
      executes PickProduct, :when => has_relation?(:basket)
      executes SearchProducts, :when => has_relation?(:search)
    # end
    
  end

  it "buys some products" do
    Mikyung.new(Buy.new).run('http://localhost:3000/')
  end
  
end