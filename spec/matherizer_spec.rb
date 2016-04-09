require 'spec_helper'

describe Matherizer do
  it 'has a version number' do
    expect(Matherizer::VERSION).not_to be nil
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
      node = OperationNode.new(:+, 1, 1)
      expect(node.value).to eq 2 
    end

    it "accepts nested operators" do
      node = OperationNode.new(:*)
      node.right_operand = OperationNode.new(:+, 1, 1)
      node.left_operand = 2
      expect(node.value).to eq 4
    end

    it "accepts nested operators through blocks" do
      node =  OperationNode.new(:-) do |n|
        n.right_operand = -6
        n.left_operand = OperationNode.new(:*) do |n|
          n.right_operand = 4
          n.left_operand = OperationNode.new(:/) do |n|
            n.left_operand = 2
            n.right_operand = OperationNode.new(:+, 2, 3.33)
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
end
