class ApplicationController < ActionController::Base
  
  include ActionFlow::Filters
  
  ActionFlow.configure do
    flow :steps,    settings.one, settings.two, settings.three
    flow :process,  settings.intro, :steps, settings.outro(:id => find(:text))
  end
  
end

