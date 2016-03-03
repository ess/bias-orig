require 'spec_helper'

module Bias
  module Algorithm
    describe TFIDF do
      let(:storage) {Bias::Storage::Memory.new}
      let(:data_set) {Bias::DataSet.new(name: 'base', storage: storage)}
      let(:tokenizer) {Bias::Tokenizer.stem_tokenizer}
      let(:algorithm) {described_class.new(data_set: data_set, tokenizer: tokenizer)}
      let(:text) {"I like chocolate milkshakes."}
      let(:category) {'pregnant'}

      it 'has the Bias Algorithm API' do
        expect(algorithm).to be_a(Bias::Algorithm::Base)
      end

      describe '#text_probability_for_category' do
        it 'tokenizes the text' do
          expect(tokenizer).to receive(:words_for).with(text).and_call_original

          algorithm.text_probability_for_category(text, category)
        end

        it 'is a floating-point number' do
          expect(algorithm.text_probability_for_category(text, category)).
            to be_a(Float)
        end

        it 'is the sum of the probabilities that each word belongs to the category' do
          expect(algorithm).to receive(:word_probability_for_category).exactly(3).times.and_return(1.0)

          expect(algorithm.text_probability_for_category(text, category)).to eql(3.0)
        end
      end

    end
  end
end
