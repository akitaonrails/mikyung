require 'rubygems'
require 'restfulie'

list = Restfulie.at("http://localhost:3000/items").accepts("application/xml").get

basket = {:items => [{:id => list.item[1]["id"]}]}

basket = list.basket.post!(basket.to_xml(:root => "basket"))

payment = {:cardnumber => "4850000000000001", :cardholder => "guilherme silveira", :amount => basket.price}

receipt = basket.payment.post!(payment.to_xml(:root => "payment"))