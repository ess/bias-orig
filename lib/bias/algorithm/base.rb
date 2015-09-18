require 'optionally/required'

module Bias
  module Algorithm
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
        probs = {}
        categories.each do |category|
          probs[category] = text_probability_for_category(text, category)
        end

        probs.map {|category, score| [category, score]}.
          sort {|left, right| right[1] <=> left[1]}
      end

      private
      def categories
        data_set.categories
      end
    end

    class IncompleteAlgorithm < StandardError
    end
  end
end
