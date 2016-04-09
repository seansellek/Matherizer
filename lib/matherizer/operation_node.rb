module Matherizer
  class OperationNode
    class MissingOperand < ArgumentError; end
    attr_accessor :operator, :left_operand, :right_operand

    def initialize operator, left_operand = nil, right_operand = nil, value_node = ValueNode, &block
      @operator = operator
      @left_operand = left_operand
      @right_operand = right_operand
      @value_node = value_node
      yield self if block_given?
    end

    def value
      raise MissingOperand.new unless right_operand && right_operand
      prepare_operands
      left_operand.value.to_f.public_send(operator, right_operand.value)
    end

    private

    def prepare_operands
      @left_operand = @value_node.new(left_operand) unless left_operand.respond_to?(:value)
      @right_operand = @value_node.new(right_operand) unless right_operand.respond_to?(:value)
    end

  end
end
