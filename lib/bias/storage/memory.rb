require 'bias/storage'
require 'bias/storage/memory/data_structures'
require 'bias/util'
require 'forwardable'

module Bias
  module Storage

    # Memory storage adapter
    class Memory
      extend Forwardable
      include DataStructures

      def_delegator Bias::Util, :normalize, :normalized
      def_delegator Bias::Util, :separator, :boundary_marker

      # Necessary methods

      def category_count
        categories.length
      end

      def get_link(category, word)
        category = normalized(category)
        word = normalized(word)

        categorizations[link_name(category, word)] ||
          {word: word, category: category, occurrences: 0}
      end

      def links_for_category(category)
        categorizations.keys.select {|key|
          key.split(boundary_marker).first == normalized(category)
        }.map {|key|
          categorizations[key]}
      end

      def links_for_word(word)
        categorizations.keys.select {|key| key.split(boundary_marker).last == normalized(word)}.map {|key| categorizations[key]}
      end

      def record_link(category, word)
        word, category = normalized(word, category)

        record_category(category)
        record_word(word)
        link = get_link(category, word)
        link[:occurrences] += 1
        categorizations[link_name(category, word)] = link
      end

      def record_sample(category, text)
        category = normalized(category)

        sample_category(category).push(text)
      end

      def sample_count(category)
        sample_category(category).length
      end

      def total_sample_count
        samples.values.map {|list| list.length}.inject(:+)
      end
      
      def word_count
        words.length
      end

      def word_known?(word)
        words.include?(normalized(word))
      end

      def category_known?(category)
        categories.include?(normalized(category))
      end


      private
      # Superfluous methods

      def record_category(category)
        category = normalized(category)

        unless category_known?(category)
          categories.push(category)
        end
      end

      def record_word(word)
        word = normalized(word)
        words.push(word) unless words.include?(word)
      end

      def link_name(category, word)
        category = normalized(category)
        word = normalized(word)

        "#{category}#{boundary_marker}#{word}"
      end

      #def existing_link?(category, word)
        #!categorizations[link_name(category, word)].nil?
      #end

      #def get_category(category)
        #category = normalized(category)

        #category_known?(category) ? category : nil
      #end

      def sample_category(category)
        samples[category] ||= []
      end
    end
  end
end
