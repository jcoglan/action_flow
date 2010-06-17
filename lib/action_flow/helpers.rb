module ActionFlow
  module Helpers
    
    def next_in_flow(name = nil, params = {})
      @flow_controller.pick_next_action(name, params)
    end
    
    def in_flow?(name)
      @flow_controller.in_flow?(name)
    end
    
    def in_any_flow?
      @flow_controller.in_any_flow?
    end
    
  end
end

