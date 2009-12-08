class ApplicationController < ActionController::Base
  
  include ActionFlow::Filters
  
  ActionFlow.configure do
    flow :steps,    settings.one,
                    settings.two,
                    settings.three
    
    flow :large,    settings.four,
                    settings.five,
                    settings.six,
                    settings.seven,
                    settings.eight
    
    flow :process,  settings.intro + application.other,
                    :steps,
                    settings.outro(:id => find(:text))
    
    flow :pass,     settings.passthrough,
                    settings.intro
  end
  
end

