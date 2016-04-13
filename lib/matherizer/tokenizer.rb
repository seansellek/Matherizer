require 'matherizer/tokenizer/splitter'
require 'matherizer/tokenizer/converter'

module Matherizer
  module Tokenizer
    def self.call expression
      token_array = Splitter.call(expression)
      Converter.call(token_array)
    end
  end
end
