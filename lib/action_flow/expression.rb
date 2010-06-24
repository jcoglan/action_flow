module ActionFlow
  class Expression
    
    def initialize(controller, params, &block)
      @params     = params.dup
      @controller = (@params.delete(:controller) || controller).to_s
      @action     = @params.delete(:action).to_s if @params[:action]
      @format     = @params.delete(:format).to_s if @params[:format]
      @matcher    = block
    end
    
    def self.from_hash(hash)
      new(nil, hash)
    end
    
    def +(expression)
      self.class::Group.new + self + expression
    end
    
    def *(expression)
      @format = expression.instance_eval { @controller }
      @action = nil
      self
    end
    
    def /(expression)
      expression.nesting = @controller
      expression
    end
    
    def nesting=(name)
      @controller = "#{ name }/#{ @controller }"
    end
    
    def method_missing(name, params = {}, &block)
      @format = name.to_s if @action
      @action ||= name.to_s
      @params.update(params) if Hash === params
      @matcher = block if block_given?
      self
    end
    
    def verb=(verb)
      @verb = verb.to_s
    end
    
    def ===(context)
      p, req = context.params, context.request
      
      return false if (@controller != p[:controller].to_s)     or
                      (@action and @action != p[:action].to_s) or
                      (@verb and !req.__send__("#{ @verb }?")) or
                      (@format and @format != p[:format].to_s)
      
      return false unless @params.all? do |key, value|
        Variable === value ||
        (value == p[key]) || (value == p[key].to_s) ||
        (value === p[key]) || (value === p[key].to_i)
      end
      
      @matcher ? context.instance_eval(&@matcher) : true
    end
    
    def to_params(env = {})
      options = {:controller => '/' + @controller}
      options[:action] = @action || :index
      options[:format] = @format if @format
      
      @params.each do |key, value|
        value = value.lookup(env) if Variable === value
        options[key] = value
      end
      
      options
    end
    
    def inspect
      source = @controller.dup
      source << ".#{ @action }" if @action
      source << "(#{ @params.map { |k,v| ":#{k} => #{v.inspect}" } * ', ' })" unless @params.empty?
      source << "#{ @action ? '.' : '*' }#{ @format }" if @format
      source = "#{ @verb }(#{ source })" if @verb
      source
    end
    
    class Group
      include Enumerable
      
      def initialize
        @exprs = []
      end
      
      def each(&block)
        @exprs.each(&block)
      end
      
      def +(expression)
        Enumerable === expression ?
            expression.each { |exp| @exprs << exp } :
            @exprs << expression
        self
      end
      
      def verb=(verb)
        each { |exp| exp.verb = verb }
      end
      
      def ===(context)
        any? { |exp| exp === context }
      end
    end
    
    module Generator
      def method_missing(name, params = {}, &block)
        Expression.new(name, params, &block)
      end
      
      %w[get post put head delete].each do |verb|
        module_eval <<-EOS
          def #{verb}(*exprs, &block)
            group = exprs.inject { |grp, exp| grp + exp }
            group.verb = :#{verb}
            group
          end
        EOS
      end
      
      def find(symbol)
        Variable.new(symbol)
      end
    end
    
  end
end

