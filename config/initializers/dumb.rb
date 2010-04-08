class OpenSearchEngine
  
  def initialize(uri)
    @description = Restfulie.at(link.href).get!
  end
  
  include Restfulie::Client::HTTP::RequestMarshaller
  
end

module Restfulie::Common::Representation

  class OpenSearch

    cattr_reader :media_type_name
    @@media_type_name = 'application/opensearchdescription+xml'

    cattr_reader :headers
    @@headers = { 
      :get  => { 'Accept'       => media_type_name },
      :post => { }
    }

    #Convert raw string to rAtom instances
    def unmarshal(content)
      content
    end

    def marshal(string)
      string
    end
    
    # prepares a link request element based on a relation.
    def prepare_link_for(link)
      if link.rel=="search"
        OpenSearchEngine.new(link.href)
      else
        link
      end
    end
    
  end

end


