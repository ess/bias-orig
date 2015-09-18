require 'optionally'
require 'bias/storage'

module Bias
  
  # Dataset interface
  class DataSet
    include Optionally::Required

    attr_reader :name

    def initialize(options = {})
      check_required_options(options, :name, :storage)

      @name = options[:name]
      @storage = options[:storage]
      Bias::Storage.check_adapter(@storage)
    end

    def categorize_word(category, word)
      storage.record_link(category, word)
    end

    def category_count
      storage.category_count
    end

    def word_count
      storage.word_count
    end

    def classification_count_for_word(word)
      storage.links_for_word(word).length
    end

    def word_usage_count_for_category(word, category)
      storage.get_link(category, word)[:occurrences]
    end

    def sample_count_for_category(category)
      storage.sample_count(category)
    end

    def total_word_usage_count(word)
      storage.links_for_word(word).map {|link| link[:occurrences]}.inject(:+) || 0
    end

    def words_for_category(category)
      storage.links_for_category(category).map {|link| link[:word]}
    end

    def add_sample(category, text)
      storage.record_sample(category, text)
    end

    def total_sample_count
      storage.total_sample_count
    end

    def known_word?(word)
      storage.word_known?(word)
    end

    def known_category?(category)
      storage.category_known?(category)
    end

    def categories
      storage.categories
    end

    private
    def storage
      @storage
    end
  end
end
