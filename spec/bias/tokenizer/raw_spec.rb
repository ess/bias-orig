require 'spec_helper'
require 'bias/tokenizer/raw'

module Bias
  module Tokenizer
    describe Raw do
      let(:tokenizer) {described_class.new}
      let(:word) {"Test2"}

      it 'is a Bias Tokenizer' do
        expect(described_class.included_modules).
          to include(Bias::Tokenizer::Base)
      end

      describe '#tokenize_word' do
        let(:tokenized) {tokenizer.tokenize_word(word)}

        it 'is a string' do
          expect(tokenized).to be_a(String)
        end

        it 'is the downcased form of the word' do
          expect(tokenized).to eql(word.downcase)
        end
      end
    end
  end
end
