module Matherizer
  module ExpressionTreeBuilder
    def self.call sexp
      operand_node_for sexp
    end

    def self.operand_node_for operand
      if operand.is_a?(Array)
        OperationNode.new(operand[0]) do |n|
          n.left_operand  = operand_node_for operand[1]
          n.right_operand = operand_node_for operand[2]
        end
      else
        ValueNode.new(operand)
      end
    end
  end
end
