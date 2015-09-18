require 'spec_helper'
require 'bias/storage/memory'
require 'bias/data_set'

module Bias
  describe DataSet do
    let(:memory) {Bias::Storage::Memory.new}
    let(:data_set) {described_class.new(name: 'test', storage: memory)}
    let(:word) {'word'}
    let(:category) {'category'}
    let(:fruits) {['apple', 'banana', 'quince']}

    describe '#known_word?' do
      it 'is false for unknown words' do
        expect(data_set.known_word?(word)).to eql(false)
      end

      it 'is true for a known word' do
        data_set.categorize_word(category, word)

        expect(data_set.known_word?(word)).to eql(true)
      end
    end
    describe '#categorize_word' do
      it 'normalizes and records unfamiliar categories' do
        expect(data_set.known_category?(category)).to eql(false)

        data_set.categorize_word(category, word)

        expect(data_set.known_category?(category)).to eql(true)
      end

      it 'records unfamiliar words' do
        expect(data_set.known_word?(word)).to eql(false)

        data_set.categorize_word(category, word)

        expect(data_set.known_word?(word)).to eql(true)
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
