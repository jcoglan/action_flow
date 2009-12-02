require 'forwardable'

module ActionFlow
  class Flow
    
    class Controller
      extend Forwardable
      def_delegators :@context, :params, :session, :request
      
      def initialize(context)
        @context = context
      end
      
      def in_flow?(name)
        status.has_key?(name)
      end
      
      def current_flow
        @current_flow ||= status.values.find { |state| state.current_matches?(self) }
      end
      
      def update_session!
        if name = new_flow_candidate
          status[name] = State.new(name)
        end
        
        status.each do |name, state|
          state.progress! if state.next_matches?(self)
          status.delete(name) if state.complete?
        end
      end
      
      def pick_next_action(flow_name = nil)
        flow = status[flow_name] || current_flow
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
    
  end
end

