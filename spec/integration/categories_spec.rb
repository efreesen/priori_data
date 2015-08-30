describe PrioriData::Integration::Categories do
  let(:instance) { described_class.new }

  describe '.import' do
    subject do
      VCR.use_cassette("apple_categories_success") do
        described_class.import
      end
    end

    after do
      subject
    end

    before do
      allow(described_class).to receive(:new).and_return(instance)
    end

    it 'creates an instance' do
      expect(described_class).to receive(:new).and_call_original
    end

    it 'calls import on instance' do
      expect(instance).to receive(:import)
    end
  end

  describe '#import' do
    context 'when service is available' do
      context 'and response is success' do
        subject do
          VCR.use_cassette("apple_categories_success") do
            instance.import
          end
        end

        #TODO
      end

      context 'and response is failure' do
        subject do
          VCR.use_cassette("apple_categories_failure") do
            instance.import
          end
        end

        it 'raises AppleServiceChangedException' do
          expect{subject}.to raise_error(PrioriData::AppleServiceChangedException)
        end
      end
    end

    context 'when service is not available' do
      subject { instance.import }

      before do
        allow(HTTParty).to receive(:get).and_raise(Errno::EHOSTUNREACH)
      end

      it 'raises AppleServiceNotAvailableException' do
        expect{subject}.to raise_error(PrioriData::AppleServiceNotAvailableException)
      end
    end
  end
end
