require File.dirname(__FILE__) + '/promotional_rule.rb'
require File.dirname(__FILE__) + '/item.rb'

module CheckoutSystem

  class Checkout

    def initialize( promotional_rules = [] )
      @basket = {} # item units
      @price = {}
      @promotional_rules = promotional_rules
    end

    def scan( item )
      @basket[item] ||= 0
      @basket[item] += 1

      # original prices
      @price[item] = Item.catalog[item].price
    end

    def total
      @discount = 0
      
      # calculate initial total
      current_total
      #print("before discounts")

      # apply discounts
      
      @promotional_rules.each do |rule|  
        rule.apply_to(self)
        current_total
        #print("after discount #{rule.name}")
      end

      return sprintf("%.2f", @total ).to_f
    end

    private

    def current_total
      @total = 0

      @basket.each do |item, quant|
        @total += @price[item] * quant
      end

      @total -= @discount
    end

    # display checkout data
    def print( label = "" )
      puts label
      puts "-"*20
      @basket.each do |item, quant|
        puts "#{quant} x #{item} = #{@price[item]} "
      end
      puts "-"*20
      puts "total: #{sprintf("%.2f", @total )}"
    end

  end

end