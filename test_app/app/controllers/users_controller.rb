class UsersController < ApplicationController
  def new
  end
  
  def create
    return next_in_flow if request.post?
  end
  
  def settings
  end
end

