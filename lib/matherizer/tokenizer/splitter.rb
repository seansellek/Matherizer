require 'strscan'
module Matherizer
  module Tokenizer
    module Splitter
      def self.call(expression)
        s = StringScanner.new(expression)
        expression.gsub(/([^\s\d\.\*]|\*\*)/, ' \1 ').split(' ')
      end
    end
  end
end
