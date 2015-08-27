require 'spec_helper'
require 'bias/trainer'
require 'bias/tokenizer'

module Bias
  describe Trainer do
    let(:tokenizer) {Bias::Tokenizer.stem_tokenizer}
    let(:storage) {Toady.new}
    let(:trainer) {described_class.new(tokenizer: tokenizer, storage: storage)}

    describe '#train' do
      it 'tokenizes the text'
    end
  end
end
