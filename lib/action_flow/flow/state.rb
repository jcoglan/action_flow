module ActionFlow
  class Flow
    
    class State
      attr_reader :variables
      
      def initialize(flow_name)
        @name      = flow_name
        @flow      = ActionFlow.flows[flow_name]
        @index     = 0
        @variables = {}
        @complete  = false
      end
      
      def current_matches?(context)
        @flow.match_at?(@index, context)
      end
      
      def progress!(context)
        @index += 1 if @flow.match_at?(@index + 1, context)
        return if current_matches?(context)
        @complete = true if @index == @flow.length - 1
      end
      
      def complete?
        @complete
      end
      
      def next_action
        @flow.action_at(@index + 1, variables)
      end
    end
    
  end
end

