require 'spec_helper'
require 'bias/storage/memory'
require 'bias/tokenizer'
require 'bias/algorithm/base'

module Bias
  module Algorithm
    describe Base do
      let(:storage) {Bias::Storage::Memory.new}
      let(:data_set) {Bias::DataSet.new(name: 'base', storage: storage)}
      let(:tokenizer) {Bias::Tokenizer.stem_tokenizer}
      let(:base) {described_class.new(data_set: data_set, tokenizer: tokenizer)}

      it 'requires a data set' do
        expect {described_class.new(tokenizer: tokenizer)}.to raise_error(ArgumentError)
        expect {described_class.new(data_set: data_set, tokenizer: tokenizer)}.
          not_to raise_exception
      end

      it 'requires a tokenizer' do
        expect {described_class.new(data_set: data_set)}.to raise_error(ArgumentError)
        expect {described_class.new(data_set: data_set, tokenizer: tokenizer)}.
          not_to raise_exception
      end

      it 'has a data_set reader' do
        expect(base.data_set).to eql(data_set)
      end

      it 'has a tokenizer reader' do
        expect(base.tokenizer).to eql(tokenizer)
      end

      describe '#text_probability_for_category' do
        it 'raises an error if not defined by a subclass' do
          expect {base.text_probability_for_category('foo', 'bar')}.
            to raise_exception(Bias::Algorithm::IncompleteAlgorithm)
        end
      end

      describe '#category_scores' do
        let(:trainer) {Bias::Trainer.new(data_set: data_set, tokenizer: tokenizer)}
        let(:category_scores) {base.category_scores('foo')}

        before(:each) do
          allow(base).
            to receive(:text_probability_for_category).
            with('foo', 'cat').
            and_return(1.0)

          allow(base).
            to receive(:text_probability_for_category).
            with('foo', 'dog').
            and_return(0.5)

          trainer.train('cat', 'I r a cat')
          trainer.train('dog', 'I r a dog')
        end

        it 'is an array' do
          expect(category_scores).to be_a(Array)
        end

        it 'is made up of category-score arrays' do
          category_scores.each do |category_score|
            expect(category_score.length).to eql(2)
            expect(category_score[0]).to be_a(String)
            expect(category_score[1]).to eql(base.text_probability_for_category('foo', category_score[0]))
          end
        end

        it 'is ordered by decreasing probability' do
          expect(category_scores[0][1]).to eql(1.0)
          expect(category_scores[1][1]).to eql(0.5)
        end
      end
    end
  end
end
