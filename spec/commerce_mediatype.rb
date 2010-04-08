class Restfulie::Common::Representation::Commerce

  cattr_reader :media_type_name
  @@media_type_name = 'application/commerce+atom+xml'

  cattr_reader :headers
  @@headers = { 
    :get  => { 'Accept'       => media_type_name },
    :post => { 'Content-type' => media_type_name }
  }

  #Convert raw string to rAtom instances
  def unmarshal(content)
    Restfulie::Common::Representation::Atom.new.unmarshal(content)
  end

  def marshal(content, rel)
    if(rel=="basket")
      
      # DEVERIA TER SIDO UM ATOMZINHO... TODO
      # <?xml version="1.0" encoding="UTF-8"?>
      # <feed xmlns="http://www.w3.org/2005/Atom">
      #   <id>new basket</id>
      #   <title>new basket</title>
      #   <updated>2010-04-08T18:54:59Z</updated>
      #   <entry xmlns:items="http://localhost:3000/items" xmlns:item="http://openbuy.com/media/item">
      #     <id>${k[:id]}</id>
      #     <item:quantity>${k[:quantity]}</item:quantity>
      #   </entry>
      # </feed>
      
      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<basket>"
      content.each do |k|
        xml << "<item><id>#{k[:id]}</id><quantity>#{k[:quantity]}</quantity></item>"
      end
      xml << "</basket>"
      xml
    elsif rel="payment"
      # TO ATOM!
      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<payment>"
      xml << "<name>#{content[:creditcard_holder]}</name>"
      xml << "<number>#{content[:creditcard_number]}</number>"
      xml << "<code>#{content[:creditcard_code]}</code>"
      xml << "<expires>#{content[:creditcard_expires]}</expires>"
      xml << "<amount>#{content[:amount]}</amount>"
      xml << "</payment>"
      xml
    else
      content
    end
  end
  
  # prepares a link request element based on a relation.
  def prepare_link_for(link)
    link
  end
  
end

Restfulie::Client::HTTP::RequestMarshaller.register_representation("application/commerce+atom+xml", Restfulie::Common::Representation::Commerce)
