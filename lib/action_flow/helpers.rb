require 'forwardable'

module ActionFlow
  module Helpers
    
    extend Forwardable
    def_delegators :@flow_controller, :in_flow?, :in_any_flow?
    
    def next_in_flow(name = nil, params = {})
      @flow_controller.pick_next_action(name, params)
    end
    
  end
end

