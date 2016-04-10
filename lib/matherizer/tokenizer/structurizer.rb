module Matherizer
  module Tokenizer
    module Structurizer
      def self.call(token_array)
        tokens = token_array.each_with_index
        result = []
        stack = {}
        loop do
          current, i = tokens.next
          case current
          when Numeric
           stack[:operands] ||= []
           stack[:operands] << current
          when :+, :-, :/, :*, :**
            stack[:operator] = current
          end
          if stack[:operands].length == 2
            result << stack[:operator]
            result.push *stack[:operands]
          end
        end
        result
      end


    end
  end
end
