require 'strscan'

module Matherizer
  class ExpressionParser < StringScanner
    OPERATOR = /[\+\/\*{1,2}]/
    VALUE = /[\d.]+/

    def self.call expression
      self.new(expression).call
    end

    def call
      expression = []
      return matched.to_f if scan(VALUE) && eos?
      reset
      if scan(/-/)
        expression[0] = :*
        expression[1] = -1
        expression[2] = ExpressionParser.call(rest)
        return expression
      end
      if scan(/(?<lop>#{VALUE})(?<op>#{OPERATOR})(?<rop>#{VALUE})/)
        operation = Tokenizer::Converter.call([self[:op], self[:lop], self[:rop]])
        if eos?
          return operation
        else
          expression[1] = operation
          expression[0] = scan(OPERATOR).to_sym
          expression[2] = ExpressionParser.call(rest)
          return expression
        end
      end
    end

  end
end
