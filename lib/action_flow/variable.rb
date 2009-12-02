module ActionFlow
  class Variable
    
    def initialize(symbol)
      @name = symbol
    end
    
    def lookup(env)
      env[@name]
    end
    
  end
end

