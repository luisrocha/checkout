# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include CheckoutSystem

describe "Checkout" do

  before do

    # item catalog initialization
    @items = [
      Item.new( "001", "Travel Card Holder", 9.25 ),
      Item.new( "002", "Personalised cufflinks", 45.00 ),
      Item.new( "003", "Kids T-shirt", 19.95 )
    ]

    # promotional rules definition
    def promo_rule_1
      PromotionalRule.new( "special price for buying 2 or more cards" ) do
        if @basket["001"] >= 2
          @price["001"] = 8.50
        end
      end
    end

    def promo_rule_2
      PromotionalRule.new( "10% discount on buys over 60£" ) do
        if @total > 60.0
          @discount = @total * 0.10
        end
      end
    end

  end

  context "with sample data" do

    before do
      @promotional_rules = [promo_rule_1, promo_rule_2]
    end

    # examples and tests

    it "does apply 10% discount on total price" do
      co = Checkout.new(@promotional_rules)
      co.scan("001")
      co.scan("002")
      co.scan("003")
      co.total.should == 66.78
    end

    it "does apply promotional price for cards" do
      co = Checkout.new(@promotional_rules)
      co.scan("001")
      co.scan("003")
      co.scan("001")
      co.total.should == 36.95
    end

    it "does apply both promotional rules" do
      co = Checkout.new(@promotional_rules)
      co.scan("001")
      co.scan("002")
      co.scan("001")
      co.scan("003")
      co.total.should == 73.76
    end

  end

  context "with other rules" do

    before do

      # add new promotional rules
      def promo_rule_3
        PromotionalRule.new( "free t-shirt for each other 2 t-shirts" ) do
          @basket["003"] = ( 2 * @basket["003"] ) / 3
          # or possibly
          # @discount += ( @basket["003"] / 3 ) * @price["003"]
        end
      end

      def promo_rule_4
        PromotionalRule.new( "30% discount on all products over 10£" ) do
          @basket.each do |item, quant|
            if @price[item] > 10.0
              @price[item] *= 0.70
              # or possibly
              # @discount += @price[item] * 0.30 * quant
            end
          end
        end
      end

      @promotional_rules = [promo_rule_1, promo_rule_3, promo_rule_4, promo_rule_2]
      
    end

    it "does apply rules 1, 3 and 4" do
      co = Checkout.new(@promotional_rules)
      co.scan("001")
      co.scan("003")
      co.scan("001")
      co.scan("003")
      co.scan("003")
      co.total.should == 44.93
    end

    it "is affected by the rules order" do
      @promotional_rules = [promo_rule_2, promo_rule_1, promo_rule_3, promo_rule_4]
      co = Checkout.new(@promotional_rules)
      co.scan("001")
      co.scan("003")
      co.scan("001")
      co.scan("003")
      co.scan("003")
      co.total.should == 37.09
    end

  end

end
