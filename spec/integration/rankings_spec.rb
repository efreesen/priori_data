describe PrioriData::Integration::Rankings do
  let(:instance) { described_class.new(6001) }

  describe '.import' do
    subject do
      VCR.use_cassette("apple_rankings_success") do
        described_class.import(6001)
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
          VCR.use_cassette("apple_rankings_success") do
            instance.import
          end
        end

        after do
          subject
        end

        it 'maps rankings' do
          expect(instance).to receive(:map_rankings)
        end
      end

      context 'and response is failure' do
        subject do
          VCR.use_cassette("apple_rankings_failure") do
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

  describe '#map_rankings' do
    context 'with a test JSON' do
      let(:json) do 
        {
          "topCharts" => [
            {
              "adamIds" => [327193945],
              "title"   => "Top Paid iPhone Apps"
            }
          ]
        }
      end

      subject { instance.map_rankings(json) }

      after do
        subject
      end

      it 'creates an app' do
        expect(PrioriData::Integration::Apps).to receive(:import).with(327193945)
      end

      it 'creates a ranking' do
        expect(PrioriData::Repositories::Ranking).to receive(:persist).with(6001, :paid, 1, 327193945)
      end
    end

    context 'with a valid JSON' do
      
    end
  end
end
