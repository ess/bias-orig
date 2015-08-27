require 'spec_helper'
require 'lingua/stemmer'
require 'bias/tokenizer/stems'

module Bias
  module Tokenizer
    describe Stems do
      let(:tokenizer) {described_class.new}
      let(:stemmable_word) {"Really"}
      let(:unstemmable_word) {"Test2"}

      it 'is a Bias Tokenizer' do
        expect(described_class.included_modules).
          to include(Bias::Tokenizer::Base)
      end

      describe '#tokenize_word' do
        let(:tokenized) {tokenizer.tokenize_word(stemmable_word)}

        it 'is a string' do
          expect(tokenized).to be_a(String)
        end

        it 'is the downcased stem form of a stemmable word' do
          expected = Lingua::Stemmer.
            new(language: 'en').
            stem(stemmable_word).
            downcase

          expect(tokenized).to eql(expected)
        end

        it 'is the downcased form of an unstemmable word' do
          expect_any_instance_of(Lingua::Stemmer).not_to receive(:stem)
          expected = unstemmable_word.downcase
          expect(tokenizer.tokenize_word(unstemmable_word)).to eql(expected)
        end
      end
    end
  end
end
