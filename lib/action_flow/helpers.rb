module ActionFlow
  module Helpers
    
    def next_in_flow
      Flow::Watcher.new(self).pick_next_action
    end
    
    def in_flow?(flow_name)
      status = session[:flow_status]
      status && status[0] == flow_name
    end
    
  end
end

