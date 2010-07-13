require 'forwardable'

module ActionFlow
  module Filters
    
    include Helpers
    
    def self.included(klass)
      klass.before_filter :update_flow_status
    end
    
  private
    
    def flow(name = nil)
      flow_state = name.nil? ? flow_controller.current_flow : flow_controller.status[name]
      flow_state.variables
    end
    
    def update_flow_status
      flow_controller.update_session!
    end
    
  end
end

