require 'spec_helper'

describe Restfulie do
  
  # curl -H "Accept:application/atom+xml" -i http://localhost:3000/orders/1

  # curl -d "<order><name>Caelum Objects Hotel</name></order>" -H "Content-type:application/xml" -H "Accept:application/atom+xml" -i http://localhost:3000/orders
  
  it "works" do
    order = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <entry xmlns=\"http://www.w3.org/2005/Atom\">
      <title>Order 1</title>
      <id>http://localhost:3000/orders/1</id>
      <updated>2010-04-03T22:45:47Z</updated>
      <link href=\"http://localhost:3000/orders/1\" rel=\"self\"/>
    </entry>
    "
    order = Restfulie.at('http://localhost:3000/orders').as('application/atom+xml').accepts('application/atom+xml').post!(order)
    order.items.each { |item| puts items }
  end
  
end