require 'spec_helper'
require 'bias/storage'

module Bias
  describe Storage do
    before(:each) do
      described_class.reset
    end

    describe '.register' do
      it 'checks the given adapter for completeness' do
        expect(described_class).
          to receive(:check_adapter).
          with(Toady).
          and_call_original
        
        described_class.register(:toady, Toady)
      end

      it 'stores a reference to the provided adapter' do
        expect(described_class.adapters.values).not_to include(Toady)

        described_class.register(:toady, Toady)

        expect(described_class.adapters.values).to include(Toady)
      end
    end

    describe '.get_adapter' do
      context 'for a known adapter' do
        before(:each) do
          described_class.register(:toady, Toady)
        end

        it 'is the adapter' do
          expect(described_class.get_adapter(:toady)).to eql(Toady)
        end
      end

      context 'for an unknown adapter' do
        it 'raises UnknownAdapter' do
          expect {described_class.get_adapter(:flibberty)}.
            to raise_error(described_class::UnknownAdapter)
        end
      end
    end
  end
end
