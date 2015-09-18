require 'bias/algorithm/base'

module Bias
  module Algorithm
    class TFIDF < Base

      def text_probability_for_category(text, category)
        tokenizer.
          words_for(text).
          map {|word| word_probability_for_category(word, category)}.
          inject(0) {|s, probability| s + probability}
      end

      private

      def total_categories
        data_set.category_count.to_f
      end

      def word_probability_for_category(word, category)
        word_cat_count = data_set.word_usage_count_for_category(word, category).to_f
        cat_count = data_set.sample_count_for_category(category).to_f

        tf = 1.0 * word_cat_count / cat_count

        idf = Math.log10((total_categories + 2) / (data_set.classification_count_for_word(word).to_f + 1.0))


        tf * idf
      end
    end
  end
end
