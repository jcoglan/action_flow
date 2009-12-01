module ActionFlow
  module Filters
    
    def self.included(klass)
      klass.before_filter :update_flow_status
    end
    
    def in_flow?(name)
      # TODO
    end
    
    def next_in_flow
      redirect_to Flow::Watcher.new(self).pick_next_action
    end
    
  private
    
    def update_flow_status
      Flow::Watcher.new(self).update_session
    end
    
  end
end

