require 'optionally'

module Bias
  class Classifier
    include Optionally::Required

    attr_reader :data_set, :tokenizer

    def initialize(options = {})
      check_required_options(options, :tokenizer, :data_set)

      @data_set = options[:data_set]
      @tokenizer = options[:tokenizer]
      @min_prob = options[:min_prob]
    end

    def total_categories
      data_set.storage.category_count.to_f
    end

    def word_probability_for_category(word, category)
      word_cat_count = data_set.storage.get_link(category, word)[:occurrences].to_f
      cat_count = data_set.storage.sample_count(category).to_f

      tf = 1.0 * word_cat_count / cat_count

      idf = Math.log10((total_categories + 2) / (data_set.storage.links_for_word(word).length.to_f + 1.0))

      tf * idf
    end

    def text_prob(text, category)
      tokenizer.words_for(text).map {|word| word_probability_for_category(word, category)}.inject(0) {|s, p| s + p}
    end

    def categories
      data_set.storage.categories
    end

    def cat_scores(text)
      probs = {}
      categories.each do |category|
        probs[category] = text_prob(text, category)
      end

      probs.map {|k, v| [k,v]}.sort {|a,b| b[1] <=> a[1]}
    end

    def classify(text, default = nil)
      max_prob = min_prob
      best = nil

      scores = cat_scores(text)
      scores.each do |score|
        cat, prob = score
        if prob > max_prob
          max_prob = prob
          best = cat
        end
      end

      return default unless best

      threshold = thresholds[best] || 1.0

      scores.each do |score|
        cat, prob = score
        next if cat == best
        return default if prob * threshold > max_prob
      end

      return best
    end

    def min_prob
      @min_prob ||= 0.0
    end

    def thresholds
      @thresholds ||= {}
    end

  end
end
