%w[expression flow filters helpers].each do |file|
  require File.dirname(__FILE__) + '/action_flow/' + file
end

module ActionFlow
  class << self
    
    include Expression::Generator
    attr_reader :flows
    
    def configure(&block)
      @flows = {}
      instance_eval(&block)
    end
    
    def flow(name, *expressions)
      expressions = expressions.map { |e| Symbol === e ? @flows[e].to_a : e }.flatten
      @flows[name.to_sym] = Flow.new(expressions)
    end
    
  end
end

