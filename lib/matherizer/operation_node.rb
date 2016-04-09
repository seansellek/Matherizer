module Matherizer
  class OperationNode
    class MissingOperand < ArgumentError; end
    attr_accessor :operator, :left_operand, :right_operand

    def initialize operator, left_operand = nil, right_operand = nil, &block
      @operator = operator
      @left_operand = left_operand
      @right_operand = right_operand
      yield self if block_given?
    end

    def value
      raise MissingOperand.new unless right_operand && right_operand
      left_operand.value.to_f.public_send(operator, right_operand.value)
    end
  end
end
