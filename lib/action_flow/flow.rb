module ActionFlow
  class Flow
    
    attr_accessor :mutexes, :terminators
    
    def initialize(expressions)
      @expressions = expressions
      @mutexes     = []
      @terminators = []
    end

    def length
      @expressions.length
    end
    
    def begins_with?(context)
      match_at?(0, context)
    end
    
    def match_at?(index, context, exact = false)
      return false unless expression = @expressions[index]
      match_expression?(expression, context, exact)
    end
    
    def match_expression?(expression, context, exact = false)
      return expression.any? { |atom| match_expression?(atom, context, exact) } if Array === expression
      return ActionFlow.flows[expression] === context if Symbol === expression and not exact
      expression === context
    end
    
    def ===(context)
      @expressions.any? { |expr| match_expression?(expr, context) }
    end

    def terminates_on?(context)
      @terminators.any? { |expr| expr === context }
    end

    def match_distance(index, context)
      return 1000 unless expression = @expressions[index]
      return 0 if expression === context
      return 1 if Symbol === expression and ActionFlow.flows[expression] === context
      1000
    end
    
    def action_at(index, env, params = {})
      return nil unless expression = @expressions[index]
      return ActionFlow.flows[expression].action_at(0, env, params) if Symbol === expression
      expression.to_params(env).merge(params)
    end
    
  end
end

