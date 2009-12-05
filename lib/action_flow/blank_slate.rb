module ActionFlow
  class BlankSlate
    
    def self.include(mixin)
      super(mixin)
      @mixins ||= []
      @mixins << mixin
    end
    
    def self.new(*args, &block)
      remove_inherited_methods
      super(*args, &block)
    end
    
    def self.remove_inherited_methods
      modules = [self] + (@mixins || [])
      
      keepers = modules.inject([]) { |list, klass| list + all_methods(klass) } +
                [:__id__, :__send__, :instance_eval]
      
      undef_method *( all_methods(self, true) - keepers )
    end
    
    def self.all_methods(klass, include_ancestors = false)
      %w[public protected private].map { |viz|
        klass.__send__("#{viz}_instance_methods", include_ancestors)
      }.
      flatten.map { |m| m.to_sym }.uniq
    end
    
  end
end

