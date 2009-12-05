%w[ blank_slate
    expression
    variable
    flow
    flow/controller
    flow/state
    filters
    helpers
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
  end

end

