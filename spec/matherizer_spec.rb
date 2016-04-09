require 'spec_helper'

describe Matherizer do
  it 'has a version number' do
    expect(Matherizer::VERSION).not_to be nil
  end

  describe Matherizer::ValueNode do
    before do
      @value_node = Matherizer::ValueNode.new 6
    end
    it "returns a it's value as a float" do
      expect(@value_node.value).to eq 6.0
    end
  end

  describe Matherizer::OperationNode do
    it "performs operation on both operands" do
      node = Matherizer::OperationNode.new(:+, 1, 1)
      expect(node.value).to eq 2 
    end

    it "accepts nested operators" do
      node = Matherizer::OperationNode.new(:*)
      node.right_operand = Matherizer::OperationNode.new(:+, 1, 1)
      node.left_operand = 2
      expect(node.value).to eq 4
    end
  end
end
