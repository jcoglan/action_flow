require 'forwardable'

module ActionFlow
  module Filters
    
    extend Forwardable
    def_delegators :flow_controller, :in_flow?, :in_any_flow?
    
    def self.included(klass)
      klass.before_filter :update_flow_status
    end
    
  private
    
    def flow_controller
      @flow_controller ||= Flow::Controller.new(self)
    end
    
    def next_in_flow(name = nil, params = {})
      return nil unless action = flow_controller.pick_next_action(name, params)
      redirect_to action
    end
    
    def flow(name = nil)
      flow_state = name.nil? ? flow_controller.current_flow : flow_controller.status[name]
      flow_state.variables
    end
    
    def update_flow_status
      flow_controller.update_session!
    end
    
  end
end

