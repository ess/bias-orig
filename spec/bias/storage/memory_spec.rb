require 'spec_helper'
require 'bias/storage'
require 'bias/storage/memory'

module Bias
  module Storage
    describe Memory do
      it 'is a complete Storage adapter' do
        expect(Bias::Storage.check_adapter(described_class)).to eql(true)
      end

      describe '#category_known?'

      describe '#record_category'

      describe '#word_known?'

      describe '#record_word'

      describe '#record_link'
    end
  end
end
