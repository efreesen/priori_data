describe PrioriData::Integration::Categories do
  let(:instance) { described_class.new }

  describe '.valid_categories' do
    let(:list) { [36, 6000, 6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010, 6011, 6012, 6013, 6014, 6015, 6016, 6017, 6018, 6020, 6021, 6022, 7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008, 7009, 7010, 7011, 7012, 7013, 7014, 7015, 7016, 7017, 7018, 7019, 13001, 13002, 13003, 13004, 13005, 13006, 13007, 13008, 13009, 13010, 13011, 13012, 13013, 13014, 13015, 13017, 13018, 13019, 13020, 13021, 13023, 13024, 13025, 13026, 13027, 13028, 13029, 13030] }

    subject { described_class.valid_categories }

    it 'returns the list of valid ids' do
      expect(subject).to eq(list)
    end
  end

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

        after do
          subject
        end

        it 'creates 69 categories' do
          expect(PrioriData::Repositories::Category).to receive(:persist).exactly(69)
        end
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
