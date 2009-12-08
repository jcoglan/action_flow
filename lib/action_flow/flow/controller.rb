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
      
      def current_flow(has_next = false)
        status.values.sort_by { |state| state.match_distance(self) }.
        find_all { |state| !has_next or state.next_action }.
        first
      end
      
      def update_session!
        if name = new_flow_candidate
          status[name] = State.new(name)
        end
        
        status.each do |name, state|
          state.progress!(self)
          status.delete(name) if state.complete?
        end
      end
      
      def pick_next_action(*args)
        flow_name = args.find { |arg| Symbol === arg } || nil
        params    = args.find { |arg| Hash === arg }   || {}
        
        flow = status[flow_name] || current_flow(true)
        flow ? flow.next_action(params) : nil
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

