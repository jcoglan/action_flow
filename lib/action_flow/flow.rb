module ActionFlow
  class Flow
    
    def initialize(expressions)
      @expressions = expressions
    end
    
    def length
      @expressions.length
    end
    
    def match_at?(index, context, exact = false)
      return false unless expression = @expressions[index]
      return ActionFlow.flows[expression] === context if Symbol === expression and not exact
      expression === context
    end
    
    def ===(context)
      @expressions.any? { |expr| expr === context }
    end
    
    def match_distance(index, context)
      return 1000 unless expression = @expressions[index]
      return 0 if expression === context
      return 1 if Symbol === expression and ActionFlow.flows[expression] === context
      1000
    end
    
    def begins_with?(context)
      @expressions.first === context
    end
    
    def action_at(index, env)
      return nil unless expression = @expressions[index]
      return ActionFlow.flows[expression].action_at(0, env) if Symbol === expression
      expression.to_h(env)
    end
    
  end
end

