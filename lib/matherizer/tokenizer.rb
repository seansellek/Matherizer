module Matherizer
  module Tokenizer
    def self.call(expression)
      expression.gsub(/([^\s\d\.\*]|\*\*)/, ' \1 ').split(' ')
    end
  end
end
