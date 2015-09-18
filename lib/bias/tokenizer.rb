require 'bias/tokenizer/definitions'
require 'bias/tokenizer/base'
require 'bias/tokenizer/stems'
require 'bias/tokenizer/raw'

module Bias

  # High-level tokenizer interface
  module Tokenizer
    def self.stem_words_for(text)
      stem_tokenizer.words_for(text)
    end

    def self.raw_words_for(text)
      raw_tokenizer.words_for(text)
    end

    def self.stem_tokenizer(options = {})
      @stem_tokenizer ||= Stems.new(options)
    end

    def self.raw_tokenizer(options = {})
      @raw_tokenizer ||= Raw.new(options)
    end
  end
end
