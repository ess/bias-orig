require 'bias/storage'

module Bias
  module Storage
    class Memory
      def initialize(data_set_name = nil)
        @data_set_name = data_set_name
      end

      def category_known?(category)
        categories.include?(normalized(category))
      end

      def record_category(category)
        category = normalized(category)

        unless category_known?(category)
          categories.push(category)
        end
      end

      def word_known?(word)
        words.include?(normalized(word))
      end

      def record_word(word)
        word = normalized(word)

        unless word_known?(word)
          words.push(word)
        end
      end

      def link_name(category, word)
        category = normalized(category)
        word = normalized(word)

        "#{category}#{boundary_marker}#{word}"
      end

      def get_link(category, word)
        category = normalized(category)
        word = normalized(word)

        link = {word: word, category: category, occurrences: 0}

        if existing_link?(category, word)
          link[:occurrences] = categorizations[link_name(category, word)][:occurrences]
        end
        
        link
      end

      def existing_link?(category, word)
        !categorizations[link_name(category, word)].nil?
      end

      def record_sample(category, text)
        category = normalized(category)

        samples[category] ||= []
        samples[category].push(text)
      end

      def sample_count(category)
        samples[normalized(category)]
      end

      def record_link(category, word)
        word = normalized(word)
        category = normalized(category)

        record_category(category)
        record_word(word)
        link = get_link(category, word)
        link[:occurrences] += 1
        categorizations[link_name(category, word)] = link
      end

      def links_for_category(category)
        categorizations.keys.select {|key| key.split(boundary_marker).first == normalized(category)}.map {|key| categorizations[key]}
      end

      def links_for_word(word)
        categorizations.keys.select {|key| key.split(boundary_marker).last == normalized(word)}.map {|key| categorizations[key]}
      end

      def get_category(category)
        category = normalized(category)

        category_known?(category) ? category : nil
      end

      def samples
        @samples ||= {}
      end

      def categories
        @categories ||= []
      end

      def category_count
        categories.length
      end

      def words
        @words ||= []
      end

      def word_count
        words.length
      end

      def categorizations
        @categorizations ||= {}
      end

      private
      def normalized(text)
        text.to_s.downcase
      end

      def boundary_marker
        '-+|+-'
      end
    end
  end
end

Bias::Storage.register(:memory, Bias::Storage::Memory)
