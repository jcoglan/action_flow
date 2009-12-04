%w[ expression
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

  class DSL
    include Expression::Generator
    
    def self.all_methods(klass, include_ancestors = false)
      %w[public protected private].map { |viz| klass.__send__("#{viz}_instance_methods", include_ancestors) }.
      flatten.map { |m| m.to_sym }.uniq
    end

    def initialize(flow_register, &block)
      # Rake adds stuff to Object and may load after this class,
      # so we need to remove inherited methods on the fly to keep
      # our method_missing working.
      class << self
        undef_method *( DSL.all_methods(self, true) - @@keeper_methods )
      end
      @flow_register = flow_register
      Object.instance_method(:instance_eval).bind(self).call(&block)
    end
    
    def flow(name, *expressions)
      @flow_register.flows[name.to_sym] = Flow.new(expressions)
    end
    
    @@keeper_methods = ( all_methods(Expression::Generator) +
                         all_methods(DSL) +
                         [:__id__, :__send__, :singleton_method_undefined]
                       ).map { |m| m.to_sym }
  end

end

