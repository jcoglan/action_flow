class ImportsController < ApplicationController
  def new
  end
  
  def show
  end
  
  def create
    next_in_flow || render(:text => "We imported your contacts")
  end
end

