require 'spec_helper'
require 'bias/tokenizer'

module Bias
  describe Tokenizer do
    let(:test_string) {"Hi there, I'm a test string!"}

    describe '.stem_tokenizer' do
      it 'is a Stems Tokenizer' do
        expect(described_class.stem_tokenizer).to be_a(Bias::Tokenizer::Stems)
      end
    end

    describe '.stem_words_for' do
      it 'uses the stem tokenizer to get the word list' do
        expect(described_class.stem_tokenizer).
          to receive(:words_for).with(test_string).and_call_original

        described_class.stem_words_for(test_string)
      end
    end

    describe '.raw_tokenizer' do
      it 'is a Raw Tokenizer' do
        expect(described_class.raw_tokenizer).to be_a(Bias::Tokenizer::Raw)
      end
    end

    describe '.raw_words_for' do
      it 'uses the raw tokenizer to get the word list' do
        expect(described_class.raw_tokenizer).
          to receive(:words_for).with(test_string).and_call_original

        described_class.raw_words_for(test_string)
      end
    end
  end
end
