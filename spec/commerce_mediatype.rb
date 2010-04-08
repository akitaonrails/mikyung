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
      xml = '<?xml version="1.0" encoding="UTF-8"?>'
      xml << '<feed xmlns="http://www.w3.org/2005/Atom">'
      xml << '<id>new basket</id>'
      xml << '  <title>new basket</title>'
      content.each do |k|
        xml << '  <entry xmlns:items="http://localhost:3000/items" xmlns:item="http://openbuy.com/media/item">'
        xml << "    <id>#{k[:id]}</id>"
        xml << "    <item:quantity>#{k[:quantity]}</item:quantity>"
        xml << '  </entry>'
      end
      xml << '</feed>'
      xml
    elsif rel="payment"
      xml = '<?xml version="1.0" encoding="UTF-8"?>'
      xml << '  <entry xmlns="http://www.w3.org/2005/Atom" xmlns:payment="http://openbuy.com/payment">'
      xml << '  <id>new basket</id>'
      xml << '  <title>new basket</title>'
      xml << "  <payment:name>#{content[:creditcard_holder]}</payment:name>"
      xml << "  <payment:number>#{content[:creditcard_number]}</payment:number>"
      xml << "  <payment:code>#{content[:creditcard_code]}</payment:code>"
      xml << "  <payment:expires>#{content[:creditcard_expires]}</payment:expires>"
      xml << "  <payment:amount>#{content[:amount]}</payment:amount>"
      xml << '  </entry>'
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
