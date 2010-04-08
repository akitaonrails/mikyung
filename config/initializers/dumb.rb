class Restfulie::Common::Representation::Commerce

  cattr_reader :media_type_name
  @@media_type_name = 'application/commerce+xml'

  cattr_reader :headers
  @@headers = { 
    :get  => { 'Accept'       => media_type_name },
    :post => { }
  }

  #Convert raw string to rAtom instances
  def unmarshal(content)
    Hash.from_xml(content)
  end

  def marshal(content, rel)
    if(rel=="basket")
      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<basket>"
      content.each do |k|
        xml << "<item><id>#{k[:id]}</id><quantity>#{k[:quantity]}</quantity></item>"
      end
      xml << "</basket>"
      xml
    else
      content
    end
  end
  
  # prepares a link request element based on a relation.
  def prepare_link_for(link)
    link
  end
  
  def self.to_hash(string)
    Hash.from_xml(string).with_indifferent_access
  end
  
end

Mime::Type.register "application/commerce+xml", :commerce
Restfulie::Client::HTTP::RequestMarshaller.register_representation("application/commerce+xml", Restfulie::Common::Representation::Commerce)
Restfulie::Server::ActionController::ParamsParser.register('application/commerce+xml', Restfulie::Common::Representation::Commerce)
