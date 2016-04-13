module Matherizer
  class ExpressionParser
    class MismatchedParenthesisError < StandardError; end
    Operator = Struct.new(:symbol, :precedence, :associativity)
    OPERATORS = {
      :_  => Operator.new(:*, 4, :right),
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
      @value_stack ||= []
      @operator_stack ||= []
      loop do
        @previous_token = @token
        @token = @tokens.next
        case token_type
        when :number
          @value_stack << ValueNode.new(@token)
        when :operator
          handle_operator
        when :left_parenthesis
          @operator_stack << @token
        when :right_parenthesis
          handle_right_parenthesis
        end
      end

      until @operator_stack.empty?
        @value_stack << build_operator_node(@operator_stack.pop)
      end
      @value_stack.last
    end

    private

    def token_type
      return :number if @token.is_a?(Numeric)
      return :operator if OPERATORS.keys.include? @token
      return :left_parenthesis if @token.match(/\(/)
      return :right_parenthesis if @token.match(/\)/)

    end

    def handle_operator
      correct_unary_minus
      while lower_precedence?(current_operator, last_operator)
        @value_stack << build_operator_node(@operator_stack.pop)
      end
      @operator_stack << @token
    end

    def build_operator_node operator
      right_operand = @value_stack.pop
      left_operand = @value_stack.pop
      operator = OPERATORS[operator].symbol
      OperationNode.new(operator, left_operand, right_operand)
    end

    def lower_precedence? o1, o2
      return false unless o2
      (o1.associativity == :left && o1.precedence <= o2.precedence) || (o2.associativity == :right && o1.precedence < o2.precedence)
    end 

    def handle_right_parenthesis
      until @operator_stack.last == "("
        @value_stack << build_operator_node(@operator_stack.pop)
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

    def correct_unary_minus
      if current_operator.symbol == :- && [nil, "(", *OPERATORS.keys].include?(@previous_token)
        @value_stack << ValueNode.new(-1.0)
        @token = :_
      end
    end
  end
end
