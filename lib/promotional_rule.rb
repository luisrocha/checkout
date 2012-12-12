module CheckoutSystem

  class PromotionalRule

    attr_accessor :name
    
    def initialize( name, &block )
      @name = name
      @block = block
    end

    def apply_to( obj )
      obj.instance_eval( &@block )
    end

  end
  
end
