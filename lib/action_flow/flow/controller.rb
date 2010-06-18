require 'forwardable'

module ActionFlow
  class Flow
    
    class Controller
      extend Forwardable
      def_delegators :@context, :params, :session, :request
      
      def initialize(context)
        @context = context
        remove_legacy_objects_from_session!
        load_states_from_session!
      end
      
      def in_flow?(name)
        status.has_key?(name)
      end
      
      def in_any_flow?
        not status.empty?
      end
      
      def current_flow(has_next = false)
        status.values.
        sort_by  { |state| state.match_distance(self) }.
        find_all { |state| !has_next or state.next_action }.
        first
      end
      
      def update_session!
        if name = new_flow_candidate
          status[name] = State.new(name)
        end

        status.each do |name, state|
          state.progress!(self)
          status.delete(name) if state.terminated? || state.complete?
        end
        
        dump_states_to_session!
      end
      
      def pick_next_action(*args)
        flow_name = args.find { |arg| Symbol === arg } || nil
        params    = args.find { |arg| Hash === arg }   || {}
        
        flow_state = status[flow_name] || current_flow(true)
        flow_state ? flow_state.next_action(params) : nil
      end
      
      def status
        @states
      end
      
    private
      
      def remove_legacy_objects_from_session!
        return unless status = session[:flow_status]
        status.each do |key, value|
          status.delete(key) unless Array === value
        end
      end
      
      def load_states_from_session!
        session_data = session[:flow_status] || {}
        @states = session_data.inject({}) do |table, (flow_name, data)|
          table[flow_name] = State.from_session_object(flow_name, data)
          table
        end
      end
      
      def dump_states_to_session!
        session[:flow_status] = @states.inject({}) do |table, (flow_name, state)|
          table[flow_name] = state.to_session_object
          table
        end
      end
      
      def new_flow_candidate
        return nil unless flows = ActionFlow.flows
        flows.keys.find { |name| flows[name].begins_with?(self) }
      end
    end
    
  end
end

