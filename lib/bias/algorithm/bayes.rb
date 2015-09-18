require 'bias/algorithm/base'

module Bias
  module Algorithm
    class Bayes < Base

      def initialize(options = {})
        super(options)
        @weight = options[:weight] || 1.0
        @assumed_prob = options[:assumed_prob] || 0.1
      end

      def text_probability_for_category(text, category)
        cat_prob = data_set.sample_count_for_category(category).to_f / data_set.total_sample_count
        doc_prob = doc_prob(text, category)
        cat_prob * doc_prob
      end

      private

      def doc_prob(text, category)
        tokenizer.words_for(text).map {|w|
          word_weighted_average(w, category)
        }.inject(1) {|p,c| p * c}
      end

      def word_weighted_average(word, category, options = {})
        func = options[:func]

        # Calculates current probability
        basic_prob = func ? func.call(word, category) : word_prob(word, category)

        # count the number of times this word has appeared in all categories
        totals = data_set.total_word_usage_count(word)

        # the final weighted average
        (@weight * @assumed_prob + totals * basic_prob) / (@weight + totals)
      end

      def word_prob(word, cat)
        total_words_in_cat = total_word_count_in_cat(cat)
        return 0.0 if total_words_in_cat == 0
        data_set.word_usage_count_for_category(word, cat).to_f / total_words_in_cat
      end

      def total_word_count_in_cat(cat)
        data_set.words_for_category(cat).length
      end

    end
  end
end
