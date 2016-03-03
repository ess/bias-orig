require 'optionally/required'

module Bias
  module Algorithm

    # Descriptive Comment
    class Base
      include Optionally::Required

      attr_reader :data_set, :tokenizer

      def initialize(options = {})
        check_required_options(options, :data_set, :tokenizer)

        @data_set = options[:data_set]
        @tokenizer = options[:tokenizer]
      end

      def text_probability_for_category(text, category)
        raise IncompleteAlgorithm
      end

      def category_scores(text)
        category_probabilities(text).map {|category, score| [category, score]}.
          sort {|left, right| right[1] <=> left[1]}
      end

      private
      def categories
        data_set.categories
      end

      def category_probabilities(text)
        probs = {}
        categories.each do |category|
          probs[category] = text_probability_for_category(text, category)
        end
        probs
      end
    end

    # Descriptive Comment
    class IncompleteAlgorithm < StandardError
    end
  end
end
