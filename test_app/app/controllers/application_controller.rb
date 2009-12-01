# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  ActionFlow.configure do
    flow :signup, users.new, post(users.create), application.dashboard
  end
  
  def dashboard
    render :text => "Welcome!"
  end
end
