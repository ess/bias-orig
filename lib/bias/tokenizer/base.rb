require 'bias/tokenizer/definitions'

module Bias
  module Tokenizer
    module Base
      def initialize(options = {})
        @options = options
      end

      def words_for(text)
        text.strip!
        return [] if text == ''

        filter(split(text).map {|word| tokenize_word(word)})
      end

      def tokenize_word(word)
        raise "Do not use the base tokenizer directly"
      end

      private

      def split(text)
        text.
          split("\n").
          map {|line| preprocess(line)}.
          join(' ').
          gsub(/\p{Word}+/).
          select {|word| significant?(word.downcase)}
      end

      def filter(word_list)
        word_list.
          select {|word| !blank?(word)}.
          select {|word| significant?(word)}
      end

      def preprocess(text)
        text.
          gsub(/['`]/, '').
          gsub(/[_]/, ' ')
      end

      def blank?(word)
        word.to_s.strip == ''
      end

      def significant?(word)
        !insignificant_words.include?(word)
      end
    
      def insignificant_words
        Bias::Tokenizer::INSIGNIFICANT_WORDS
      end
    end
  end
end
