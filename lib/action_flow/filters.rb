module ActionFlow
  module Filters
    
    def self.included(klass)
      klass.before_filter :update_flow_status
    end
    
  private
    
    def flow_controller
      @flow_controller ||= Flow::Controller.new(self)
    end
    
    def in_flow?(name)
      flow_controller.in_flow?(name)
    end
    
    def next_in_flow(name = nil, params = {})
      return nil unless action = flow_controller.pick_next_action(name, params)
      redirect_to action
    end
    
    def flow
      flow_controller.current_flow.variables
    end
    
    def update_flow_status
      flow_controller.update_session!
    end
    
  end
end

