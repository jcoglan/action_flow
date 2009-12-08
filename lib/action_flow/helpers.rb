module ActionFlow
  module Helpers
    
    def next_in_flow(name = nil, params = {})
      Flow::Controller.new(self).pick_next_action(name, params)
    end
    
    def in_flow?(name)
      Flow::Controller.new(self).in_flow?(name)
    end
    
  end
end

