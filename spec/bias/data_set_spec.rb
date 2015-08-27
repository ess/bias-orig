require 'spec_helper'
require 'bias/storage/memory'
require 'bias/data_set'

module Bias
  describe DataSet do
    let(:data_set) {described_class.new(name: 'test', storage: :memory)}
    let(:word) {'word'}
    let(:category) {'category'}
    let(:fruits) {['apple', 'banana', 'quince']}

    describe '#categorize_word' do
      it 'normalizes and records unfamiliar categories' do
        expect(data_set.storage.categories).not_to include(category.downcase)

        data_set.categorize_word(category, word)

        expect(data_set.storage.categories).to include(category.downcase)
      end

      it 'records unfamiliar words' do
        expect(data_set.storage.words).not_to include(word)

        data_set.categorize_word(category, word)

        expect(data_set.storage.words).to include(word)
      end

      it 'categorizes the word' do
        expect(data_set.words_for_category(category)).not_to include(word)

        data_set.categorize_word(category, word)

        expect(data_set.words_for_category(category)).to include(word)
      end
    end

    describe '#category_count' do
      it 'is the total number of known categories' do
        categories = ['cat1', 'cat2', 'cat3']

        expect(data_set.category_count).to eql(0)

        categories.each {|cat| data_set.categorize_word(cat, word)}

        expect(data_set.category_count).to eql(categories.length)
      end
    end
  end
end
