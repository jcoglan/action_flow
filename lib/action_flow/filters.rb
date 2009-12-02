module ActionFlow
  module Filters
    
    def self.included(klass)
      klass.before_filter :update_flow_status
    end
    
  private
    
    def in_flow?(name)
      Flow::Controller.new(self).in_flow?(flow_name)
    end
    
    def next_in_flow
      return nil unless action = Flow::Controller.new(self).pick_next_action
      redirect_to action
    end
    
    
    def update_flow_status
      Flow::Controller.new(self).update_session!
    end
    
  end
end

