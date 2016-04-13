require 'spec_helper'

describe Matherizer do
  describe "::evaluate" do
    it "solves 1+1" do
      expect(Matherizer.evaluate('1+1')).to eq(2)
    end

    it "solves 1* 1" do
      expect(Matherizer.evaluate('1* 1')).to eq(1)
    end

    it "solves 1 - 1" do
      expect(Matherizer.evaluate('1 - 1')).to eq(0)
    end

    it "solves 1 /1" do
      expect(Matherizer.evaluate('1 /1')).to eq(1)
    end

    it "solves -123" do
      expect(Matherizer.evaluate('-123')).to eq(-123)
    end

    it "solves 12* 123" do
      expect(Matherizer.evaluate('12* 123')).to eq(1476)
    end

    it "solves 2 /2+3 * 4.75- -6" do
      expect(Matherizer.evaluate('2 /2+3 * 4.75- -6')).to be_within(0.01).of(21.25)
    end

    it "solves 2 / (2 + 3) * 4.33 - -6" do
      expect(Matherizer.evaluate('2 / (2 + 3) * 4.33 - -6')).to be_within(0.001).of(7.732)
    end
    
  end

  describe ValueNode do
    before do
      @value_node = ValueNode.new 6
    end
    it "returns a it's value as a float" do
      expect(@value_node.value).to eq 6.0
    end
  end

  describe OperationNode do
    it "performs operation on both operadnds" do
      node = OperationNode.new(:+, ValueNode.new(1), ValueNode.new(1))
      expect(node.value).to eq 2 
    end

    it "accepts nested operators" do
      node = OperationNode.new(:*)
      node.right_operand = OperationNode.new(:+, ValueNode.new(1), ValueNode.new(1))
      node.left_operand = ValueNode.new(2)
      expect(node.value).to eq 4
    end

    it "accepts nested operators through blocks" do
      node =  OperationNode.new(:-) do |n|
        n.right_operand = ValueNode.new(-6)
        n.left_operand = OperationNode.new(:*) do |n|
          n.right_operand = ValueNode.new(4)
          n.left_operand = OperationNode.new(:/) do |n|
            n.left_operand = ValueNode.new(2)
            n.right_operand = OperationNode.new(:+, ValueNode.new(2), ValueNode.new(3.33))
          end
        end
      end
      expect(node.value).to be_within(0.1).of(7.5)
    end
  end

  describe Tokenizer do
    describe Tokenizer::Splitter do
      it "Splits an expression into tokens" do
        expression = "(1+1)/2"
        expect(Tokenizer::Splitter.call(expression)).to eq(["(", "1", "+", "1", ")", "/", "2"])
      end

      it "Handles large numbers" do
        expression = "11 + 112"
        expect(Tokenizer::Splitter.call(expression)).to eq(["11", "+", "112"])
      end

      it "Handles exponents" do
        expression = "1**(1/2)"
        expect(Tokenizer::Splitter.call(expression)).to eq(["1", "**", "(", "1", "/", "2", ")"])
      end
    end

    describe Tokenizer::Converter do
      it "converts operators to symbols" do
        token_array = ["(", "1", "+", "1", ")", "/", "2"]
        expect(Tokenizer::Converter.call(token_array)).to eq(["(", 1.0, :+, 1.0, ")", :/, 2.0])
      end
    end
  end

  describe ExpressionParser do
    context "#parse" do
      before do
        expression = '3 + 4 * 2 / ( 1 - 5 )' 
        @expression_tree = OperationNode.new(:+) do |n|
          n.left_operand = ValueNode.new(3)
          n.right_operand = OperationNode.new(:*) do |n|
            n.left_operand = ValueNode.new(4)
            n.right_operand = OperationNode.new(:/) do |n|
              n.left_operand = ValueNode.new(2)
              n.right_operand = OperationNode.new(:-) do |n|
                n.left_operand = ValueNode.new(1)
                n.right_operand = ValueNode.new(5)
              end
            end
          end
        end
        @parsed_expression = ExpressionParser.new(expression).parse
      end

      it "Produces an expression tree" do
        expect(@parsed_expression.respond_to?(:value)).to be_truthy
      end

      it "Correctly parses infix notation" do
        expect(@parsed_expression.value).to eq(@expression_tree.value)
      end
    end
  end
end
