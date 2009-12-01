require 'forwardable'

module ActionFlow
  class Flow
    
    def initialize(expressions)
      @expressions = expressions
    end
    
    def begins_with?(context)
      match?(0, context)
    end
    
    def match?(index, context)
      @expressions[index] === context
    end
    
    def action_at(index)
      expr = @expressions[index]
      expr && expr.to_h
    end
    
    def to_a
      @expressions
    end
    
    class Watcher
      extend Forwardable
      def_delegators :@context, :params, :request, :session
      
      def initialize(context)
        @context = context
      end
      
      def pick_next_action
        return nil unless status = session[:flow_status]
        ActionFlow.flows[status[0]].action_at(status[1] + 1)
      end
      
      def update_session
        return unless flows = ActionFlow.flows
        return pick_new_flow(new_flow_candidate) unless status = session[:flow_status]
        
        flow = flows[status[0]]
        if flow.match?(status[1] + 1, @context)
          status[1] += 1
        else
          if name = new_flow_candidate
            pick_new_flow(name)
          end
        end
      end
      
      def pick_new_flow(name)
        session[:flow_status] = name ? [name,0] : nil
      end
      
      def new_flow_candidate
        ActionFlow.flows.keys.find do |flow_name|
          ActionFlow.flows[flow_name].begins_with?(@context)
        end
      end
    end
    
  end
end

