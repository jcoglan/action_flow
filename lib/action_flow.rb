%w[ blank_slate
    expression
    variable
    flow
    flow/controller
    flow/state
    helpers
    filters
].each do |file|
  require File.dirname(__FILE__) + '/action_flow/' + file
end

module ActionFlow

  class << self
    def flows
      @flows ||= {}
    end

    def configure(&block)
      DSL.new(self, &block)
    end
  end

  class DSL < BlankSlate
    include Expression::Generator
    
    def initialize(flow_register, &block)
      @flow_register = flow_register
      instance_eval(&block)
    end
    
    def flow(name, *expressions)
      @flow_register.flows[name.to_sym] = Flow.new(expressions)
    end
    
    def mutex(*names)
      names.each do |name|
        next unless flow = @flow_register.flows[name]
        flow.mutexes = names - [name]
      end
    end

    def terminate(*args)
      expression_options = args.pop

      unless expression_options.respond_to?(:[]) && expression = expression_options[:on]
        raise ArgumentError, 'Could not find :on => expression in terminate'
      end

      args.each do |arg|
        flow_name = arg.to_sym
        next unless @flow_register.flows[flow_name]
        @flow_register.flows[flow_name].terminators << expression
      end
    end
  end

end
