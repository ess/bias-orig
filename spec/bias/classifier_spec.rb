require 'spec_helper'

module Bias
  describe Classifier do
    let(:storage) {Bias::Storage::Memory.new}
    let(:tokenizer) {Bias::Tokenizer.stem_tokenizer}
    let(:data_set) {Bias::DataSet.new(name: 'classifier test', storage: storage)}
    let(:algorithm) {Bias::Algorithm::TFIDF.new(data_set: data_set, tokenizer: tokenizer)}
    let(:classifier) {described_class.new(algorithm: algorithm)}
    let(:poop_thresholds) {{'brown' => 1.0, 'green' => 2.0}}
    let(:poop_classifier) {described_class.new(algorithm: algorithm, default: 'poop', min_prob: 0.5, thresholds: poop_thresholds)}
    let(:test_string) {"Hi there, I am a test string!"}

    it 'requires an algorithm' do
      expect {described_class.new()}.to raise_error(ArgumentError)
      expect {described_class.new(algorithm: algorithm)}.not_to raise_error
    end

    it 'allows a default option' do
      expect {
        described_class.new(algorithm: algorithm, default: 'default')
      }.not_to raise_error
    end

    it 'allows a min_prob option' do
      expect {
        described_class.new(algorithm: algorithm, min_prob: 0.0)
      }.not_to raise_error
    end

    it 'allows a thresholds option' do
      expect {
        described_class.new(algorithm: algorithm, thresholds: poop_thresholds)
      }.not_to raise_error
    end

    describe '#classify' do
      it 'gets the category scores for the given text' do
        expect(algorithm).
          to receive(:category_scores).
          with(test_string).
          and_call_original

        classifier.classify(test_string)
      end

      it 'is the default option for inconclusive requests' do
        expect(classifier.classify(test_string)).to eql(nil)
        expect(poop_classifier.classify(test_string)).to eql('poop')
      end
    end

    describe '#best_score' do
      let(:scores) {
        [['one', 1.0], ['three-hundred', 300.0], ['two', 2.0], ['zero', 0.0]]
      }
      let(:best_score) {classifier.best_score(scores)}

      it 'is a two-element Array' do
        expect(best_score).to be_a(Array)
        expect(best_score.length).to eql(2)
      end

      context 'when there is a score with a non-zero probability' do
        it 'contains the winning category as the first element' do
          expect(best_score[0]).to eql('three-hundred')
        end

        it 'contains the winning probability as the second element' do
          expect(best_score[1]).to eql(300.0)
        end
      end

      context 'when there are no scores with a higher-than-minimum probability' do
        let(:scores) {[['zero', 0.0], ['one', 0.0]]}
        let(:classifier) {
          described_class.new(algorithm: algorithm, min_prob: 1.0)
        }

        it 'contains nil as the first element' do
          expect(best_score[0]).to eql(nil)
        end

        it 'contains the minimum probability as the second element' do
          expect(best_score[1]).to eql(classifier.min_prob)
        end
      end
    end

    describe '#apply_thresholds'

    describe '#thresholds' do
      it 'is an empty hash if no thresholds were provided at instantiation' do
        expect(classifier.thresholds).to eql({})
      end

      it 'is the hash of thresholds provided at instantiation' do
        expect(poop_classifier.thresholds).to eql(poop_thresholds)
      end
    end

    describe '#min_prob' do
      it 'is 0.0 if no min_prob was provided at instantiation' do
        expect(classifier.min_prob).to eql(0.0)
      end

      it 'is the min_prob value provided at instantiation' do
        expect(poop_classifier.min_prob).to eql(0.5)
      end
    end

    describe '#default' do
      it 'is nil if no default was provided at instantiation' do
        expect(classifier.default).to eql(nil)
      end

      it 'is the default value provided at instantiation' do
        expect(poop_classifier.default).to eql('poop')
      end
    end
  end
end
