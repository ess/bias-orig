require 'optionally'

module Bias

  # A classifier
  class Classifier
    include Optionally::Required

    attr_reader :algorithm

    def initialize(options = {})
      check_required_options(options, :algorithm)

      @algorithm = options[:algorithm]
      @min_prob = options[:min_prob]
    end

    def classify(text, default = nil)
      scores = algorithm.category_scores(text)

      best, max_prob = best_score(scores)
      apply_thresholds(scores,best, max_prob)
    end

    private

    def apply_thresholds(scores, best, max_prob)
      # Return the default category in case the threshold condition was
      # not met. For example, if the threshold for spam is 1.2
      #
      #   :spam => 0.73, :ham => 0.40  (OK)
      #   :spam => 0.80, :ham => 0.70  (Fail, :ham is too close)

      return default unless best

      threshold = thresholds[best] || 1.0

      scores.each do |score|
        cat, prob = score
        next if cat == best
        return default if prob * threshold > max_prob
      end

      best
    end

    def best_score(scores)
      max_prob = min_prob
      best = nil

      scores.each do |score|
        cat, prob = score
        if prob > max_prob
          max_prob = prob
          best = cat
        end
      end
      [best, max_prob]
    end

    def min_prob
      @min_prob ||= 0.0
    end

    def thresholds
      @thresholds ||= {}
    end
  end
end
