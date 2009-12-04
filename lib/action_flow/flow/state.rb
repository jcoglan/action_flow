module ActionFlow
  class Flow
    
    class State
      attr_reader :variables
      
      def initialize(flow_name)
        @name      = flow_name
        @flow      = ActionFlow.flows[flow_name]
        @index     = 0
        @max_index = 0
        @variables = {}
        @complete  = false
      end
      
      def match_distance(context)
        @flow.match_distance(@index, context)
      end
      
      def progress!(context)
        @index += 1 if @flow.match_at?(@index + 1, context)
        @max_index = [@max_index, @index].max
        return if current_matches?(context)
        
        0.upto(@max_index) do |backtrack|
          @index = backtrack if @flow.match_at?(backtrack, context)
        end
        
        @complete = true if @index == @flow.length - 1
      end
      
      def complete?
        @complete
      end
      
      def next_action
        @flow.action_at(@index + 1, variables)
      end
      
    private
      
      def current_matches?(context)
        @flow.match_at?(@index, context)
      end
    end
    
  end
end

