require 'strscan'

module Matherizer
  class ExpressionParser
    class MismatchedParenthesisError < StandardError; end
    Operator = Struct.new(:symbol, :precedence, :associativity)
    OPERATORS = {
      :+  => Operator.new(:+, 2, :left),
      :-  => Operator.new(:-, 2, :left),
      :/  => Operator.new(:/, 3, :left),
      :*  => Operator.new(:*, 3, :left),
      :** => Operator.new(:**, :right)
    }

    def initialize expression, tokenizer = Tokenizer
      @tokens = Tokenizer.call(expression).each
    end

    def parse
      @output ||= []
      @operator_stack ||= []
      loop do
        @token = @tokens.next
        case token_type
        when :number
          @output << @token
        when :operator
          handle_operator
        when :left_parenthesis
          @operator_stack << @token
        when :right_parenthesis
          handle_right_parenthesis
        end
      end

      until @operator_stack.empty?
        @output << build_operator_node(@operator_stack.pop)
      end
      @output.last
    end

    private

    def token_type
      return :number if @token.is_a?(Numeric)
      return :operator if OPERATORS.keys.include? @token
      return :left_parenthesis if @token.match(/\(/)
      return :right_parenthesis if @token.match(/\)/)
    end

    def handle_operator
      while lower_precedence?(current_operator, last_operator)
        @output << build_operator_node(@operator_stack.pop)
      end
      @operator_stack << @token
    end

    def build_operator_node operator
      right_operand = @output.pop
      left_operand = @output.pop
      OperationNode.new(operator) do |n|
        n.left_operand = left_operand.is_a?(OperationNode) ? left_operand : ValueNode.new(left_operand)
        n.right_operand = right_operand.is_a?(OperationNode) ? right_operand : ValueNode.new(right_operand)
      end
    end

    def lower_precedence? o1, o2
      return false unless o2
      (o1.associativity == :left && o1.precedence <= o2.precedence) || (o2.associativity == :right && o1.precedence < o2.precedence)
    end 

    def handle_right_parenthesis
      until @operator_stack.last == "("
        @output << build_operator_node(@operator_stack.pop)
        raise MismatchedParenthesisError if @operator_stack.empty?
      end
      @operator_stack.pop
    end

    def current_operator
      OPERATORS[@token]
    end

    def last_operator
      OPERATORS[@operator_stack.last]
    end
  end
end
