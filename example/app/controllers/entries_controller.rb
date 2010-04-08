class EntriesController < ApplicationController
  include Restfulie::Server::ActionController::Base

  respond_to :atom
  
  def index
    respond_with @what = []
  end
  
end

