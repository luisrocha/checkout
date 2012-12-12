module CheckoutSystem

  class Item

    @@catalog = {} # collection of all items for sale

    attr_reader :code
    attr_accessor :name, :price

    def self.catalog
      @@catalog
    end

    def initialize( code, name, price )
      @code = code
      @name = name
      @price = price

      @@catalog[@code] = self # add item to collection upon creation
    end

    # removes item from catalog
    def delete
      @@catalog.delete(@code)
    end

  end
  
end
