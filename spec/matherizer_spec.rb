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
    it "performs operation on both operadnds" do
      node = Matherizer::OperationNode.new(:+, 1, 1)
      expect(node.value).to eq 2 
    end

    it "accepts nested operators" do
      node = Matherizer::OperationNode.new(:*)
      node.right_operand = Matherizer::OperationNode.new(:+, 1, 1)
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
end
