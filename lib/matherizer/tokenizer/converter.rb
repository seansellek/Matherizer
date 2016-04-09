module Matherizer
  module Tokenizer
    module Converter
      def self.call token_array
        converted_tokens = []
        token_array.each do |token|
          converted_tokens << token.to_sym  and next if is_operator? token
          converted_tokens << token.to_f    and next if is_value? token
          converted_tokens << token         and next if is_parenthesis? token

          raise Exception, "Unrecognized token: #{token}"
        end
        converted_tokens
      end

      

      def self.is_value? string
        string.match /\d/
      end

      def self.is_operator? string
        string.match /[-\+\/\*]/
      end

      def self.is_parenthesis? string
        string.match /[\(\)]/
      end
    end
  end
end
