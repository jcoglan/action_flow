module ActionFlow
  module Helpers
    
    def next_in_flow(name = nil)
      Flow::Controller.new(self).pick_next_action(name)
    end
    
    def in_flow?(flow_name)
      Flow::Controller.new(self).in_flow?(flow_name)
    end
    
  end
end

