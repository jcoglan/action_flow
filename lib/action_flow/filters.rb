module ActionFlow
  module Filters
    
    def self.included(klass)
      klass.before_filter :update_flow_status
    end
    
  private
    
    def in_flow?(name)
      # TODO
    end
    
    def next_in_flow
      return nil unless action = Flow::Watcher.new(self).pick_next_action
      redirect_to action
    end
    
    
    def update_flow_status
      Flow::Watcher.new(self).update_session
    end
    
  end
end

