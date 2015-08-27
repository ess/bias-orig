require 'optionally'

module Bias
  class Trainer
    include Optionally::Required

    attr_reader :tokenizer
    attr_reader :data_set

    def initialize(options = {})
      check_required_options(options, :tokenizer, :data_set)

      @tokenizer = options[:tokenizer]
      @data_set = options[:data_set]
    end

    def train(category, text)
      data_set.add_sample(category, text)
      tokenizer.words_for(text).map {|word|
        data_set.categorize_word(category, word)
      }
    end
  end
end
