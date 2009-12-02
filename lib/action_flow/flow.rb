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
    
    def action_at(index, env)
      return nil unless expression = @expressions[index]
      return ActionFlow.flows[expression].action_at(0, env) if Symbol === expression
      expression.to_h(env)
    end
    
  end
end

