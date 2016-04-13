require "matherizer/version"
require "matherizer/operation_node"
require "matherizer/value_node"
require "matherizer/tokenizer"
require "matherizer/expression_parser"

module Matherizer
  def self.evaluate expression
    ExpressionParser.new(expression).parse.value
  end
end
