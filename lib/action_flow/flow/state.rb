module ActionFlow
  class Flow
    
    class State
      attr_reader :variables
      
      def initialize(flow_name)
        @name       = flow_name
        @flow       = ActionFlow.flows[flow_name]
        @index      = 0
        @max_index  = 0
        @variables  = {}
        @complete   = false
        @terminated = false
      end
      
      def match_distance(context)
        @flow.match_distance(@index, context)
      end
      
      def progress!(context)
        if @flow.terminates_on?(context)
          @terminated = true
          return
        end
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

      def terminated?
        @terminated
      end

      def next_action(params = {})
        @flow.action_at(@index + 1, variables, params)
      end
      
      def to_session_object
        [@index, @max_index, @variables, @complete]
      end
      
      def self.from_session_object(flow_name, data)
        instance = new(flow_name)
        instance.instance_eval do
          @index     = data[0]
          @max_index = data[1]
          @variables = data[2]
          @complete  = data[3]
        end
        instance
      end
      
    private
      
      def current_matches?(context)
        @flow.match_at?(@index, context)
      end
    end
    
  end
end

