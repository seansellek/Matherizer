module Matherizer
  module Tokenizer
    module Splitter
      def self.call(expression)
        expression.gsub(/([^\s\d\.\*]|\*\*|\*)/, ' \1 ').split(' ')
      end
    end
  end
end
