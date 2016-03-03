require 'spec_helper'
require 'bias/trainer'
require 'bias/tokenizer'

module Bias
  describe Trainer do
    #let(:tokenizer) {Bias::Tokenizer.stem_tokenizer}
    let(:tokenizer) {Object.new}
    let(:storage) {Toady.new}
    let(:data_set) {Bias::DataSet.new(name: :dummy, storage: storage)}
    let(:trainer) {described_class.new(tokenizer: tokenizer, data_set: data_set)}

    describe '#train' do
      let(:text) {"I'm a pretty princess"}
      let(:tokenized) {['pretty', 'princess']}
      let(:category) {'cat1'}

      it 'categorizes each token in the given text' do
        expect(tokenizer).to receive(:words_for).with(text).and_return(tokenized)
        tokenized.each do |token|
          expect(data_set).to receive(:categorize_word).with(category, token)
        end

        trainer.train(category, text)
      end
    end
  end
end
