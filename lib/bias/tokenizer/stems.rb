require 'bias/tokenizer/base'
require 'lingua/stemmer'

module Bias
  module Tokenizer

    # A semmer-based tokenizer
    class Stems
      include Bias::Tokenizer::Base

      def tokenize_word(word)
        return word.downcase unless stemmable?(word)

        stemmer.stem(word).downcase
      end

      private
      def stemmer
        @stemmer ||= Lingua::Stemmer.new(language: 'en')
      end


      def stemmable?(word)
        word =~ /^\p{Alpha}+$/
      end
    end
  end
end
