module Merb
  class Authorization
    
    # Grabs the namespaced constants in a class
    # :api: private
    def self._constantize_namespace(class_string)
      @_constantize_namespace ||= Hash.new do |h,k|
        result = []
        names = k.split("::")
        accumulator = []
        names.each do |name|
          accumulator << name
          result << Object.full_const_get(accumulator.join("::"))
        end
        h[k] = result
      end
      @_constantize_namespace[class_string]
    end
    
    # Checks to see if an object should execute thier allows? method. i.e. is it relevant?
    # :api: private
    def self._execute_allows?(obj, verb, opts)
      return false unless obj.respond_to?(:allows?)
      return obj._allows?(verb, opts) if obj.respond_to?(:_allows?)
      true
    end
    
    
    # :api: private
    def self.authorized?(user, verb, opts={})
      if opts[:target]
        if _execute_allows?(opts[:target], verb, opts)
          return !!opts[:target].allows?(user, verb, opts)
        else
          # Grab a class object since the item didn't respond to allows? and try each one in the namespace
          obj = case opts[:target] 
          when Class
            opts[:target]
          else
            opts[:target].class
          end
          # Grab the all the namesapced constancs of this class and find if any of it can execute it's allows?
          target = _constantize_namespace(obj.name).reverse.detect do |klass|
            Merb::Authorization._execute_allows?(klass, verb, opts)
          end
          return !!target.allows?(user,verb,opts) if target
        end
      end
      # Finally, try the global one
      !!allows?(user, verb, opts) if _execute_allows?(self, verb, opts)
    end
    
  end
end