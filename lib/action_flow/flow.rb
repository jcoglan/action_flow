require 'forwardable'

module ActionFlow
  class Flow
    
    def initialize(expressions)
      @expressions = expressions
    end
    
    def length
      @expressions.length
    end
    
    def begins_with?(context)
      @expressions.first === context
    end
    
    def match_at?(index, context)
      return false unless expression = @expressions[index]
      return ActionFlow.flows[expression] === context if Symbol === expression
      expression === context
    end
    
    def ===(context)
      @expressions.any? { |expr| expr === context }
    end
    
    def action_at(index)
      return nil unless expression = @expressions[index]
      return ActionFlow.flows[expression].action_at(0) if Symbol === expression
      expression.to_h
    end
    
    class Controller
      extend Forwardable
      def_delegators :@context, :params, :session, :request
      
      def initialize(context)
        @context = context
      end
      
      def in_flow?(name)
        status.has_key?(name)
      end
      
      def update_session!
        if name = new_flow_candidate
          status[name] = State.new(name)
        end
        
        status.each do |name, state|
          state.progress! if state.next_matches?(self)
          status.delete(name) if state.complete?
        end
        
        session[:current_flow] = status.values.find do |state|
          state.current_matches?(self)
        end
      end
      
      def pick_next_action(flow_name = nil)
        flow = status[flow_name] || session[:current_flow]
        flow ? flow.next_action : nil
      end
      
    private
      
      def status
        session[:flow_status] ||= {}
      end
      
      def new_flow_candidate
        return nil unless flows = ActionFlow.flows
        flows.keys.find { |name| flows[name].begins_with?(self) }
      end
    end
    
    class State
      def initialize(flow_name)
        @name  = flow_name
        @flow  = ActionFlow.flows[flow_name]
        @index = 0
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
        @flow.action_at(@index + 1)
      end
    end
    
  end
end

