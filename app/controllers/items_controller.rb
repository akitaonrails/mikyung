class ItemsController < Restfulie::Server::ActionController::Base

  respond_to :atom, :html
  
  def search_definition
    render :text => opensearch_definition(search_item_url), :content_type => "application/opensearchdescription+xml"
  end
  
  def search
    @query = params[:q]
    respond_with @items = Item.find_by_name(@query)
  end
  
  private
  
  def opensearch_definition(search_url)
    name = "caelum products"
    description = "caelum product search engine"
    tags = "product"
    contact = "guilherme.silveira@caelum.com.br"
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <OpenSearchDescription xmlns=\"http://a9.com/-/spec/opensearch/1.1/\">
      <ShortName>#{name}</ShortName>
      <Description>#{description}</Description>
      <Tags>#{tags}</Tags>
      <Contact>#{contact}</Contact>
      <Url type=\"application/atom+xml\" template=\"#{search_url}?q={searchTerms}&amp;pw={startPage?}&amp;\"/>
    </OpenSearchDescription>"
  end
  
end
