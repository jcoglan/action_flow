require 'forwardable'

module ActionFlow
  module Helpers
    
    extend Forwardable
    def_delegators :flow_controller, :in_flow?, :in_any_flow?, :next_in_flow
    
    def flow_controller
      @flow_controller ||= Flow::Controller.new(self)
    end
    
  end
end

