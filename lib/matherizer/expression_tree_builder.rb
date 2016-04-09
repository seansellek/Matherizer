module Matherizer
  module ExpressionTreeBuilder
    def self.call sexp
      OperationNode.new(sexp[0]) do |n|
        n.left_operand  = operand_node_for sexp[1]
        n.right_operand = operand_node_for sexp[2]
      end
    end

    def self.operand_node_for operand
      if operand.is_a?(Array)
        self.call(operand)
      else
        ValueNode.new(operand)
      end
    end
  end
end
