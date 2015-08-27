require 'spec_helper'
require 'bias/tokenizer/base'

class Dummy
  include Bias::Tokenizer::Base

  def tokenize_word(word)
    word
  end
end

module Bias
  module Tokenizer
    describe Base do
      let(:tokenizer) {Dummy.new}
      let(:test_string) {"Hi there, I am a test string!"}

      it 'provides the words_for method' do
        expect(tokenizer).to respond_to(:words_for)
      end

      it 'requires that the including class define #tokenize_word' do
        bad_dog = Object.new
        bad_dog.extend(described_class)

        expect {bad_dog.tokenize_word("test")}.to raise_error(StandardError)
      end

      describe '#words_for' do
        it 'is a collection' do
          expect(tokenizer.words_for(test_string)).to respond_to(:each)
        end

        it 'splits the given string' do
          expect(tokenizer).to receive(:split).with(test_string).and_call_original

          tokenizer.words_for(test_string)
        end

        it 'tokenizes each word in the given string' do
          expect(tokenizer).
            to receive(:tokenize_word).
            at_most(test_string.split(' ').length).times.
            and_call_original

          tokenizer.words_for(test_string)
        end

        it 'filters out insignificant words' do
          really_insignificant = Bias::Tokenizer::INSIGNIFICANT_WORDS.join(' ')

          expect(tokenizer.words_for(really_insignificant)).to be_empty
        end
      end
    end
  end
end
