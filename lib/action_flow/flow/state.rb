module ActionFlow
  class Flow
    
    class State
      attr_reader :variables
      
      def initialize(flow_name)
        @name      = flow_name
        @flow      = ActionFlow.flows[flow_name]
        @index     = 0
        @variables = {}
      end
      
      def current_matches?(context)
        @flow.match_at?(@index, context)
      end
      
      def next_matches?(context)
        @flow.match_at?(@index + 1, context)
      end
      
      def progress!
        @index += 1
      end
      
      def complete?
        @index == @flow.length - 1
      end
      
      def next_action
        @flow.action_at(@index + 1, variables)
      end
    end
    
  end
end

