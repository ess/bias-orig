require 'bias/tokenizer/base'

module Bias
  module Tokenizer
    class Raw
      include Bias::Tokenizer::Base

      def tokenize_word(word)
        word.downcase
      end
    end
  end
end
