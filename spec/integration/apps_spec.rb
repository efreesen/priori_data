describe PrioriData::Integration::Apps do
  let(:instance) { described_class.new(app_id) }
  let(:app_id) { 327193945 }

  before do
    app = OpenStruct.new(publisher_id: app_id)

    allow(PrioriData::Repositories::App).to receive(:find).and_return(app)
  end

  describe '.import' do
    subject do
      VCR.use_cassette("apple_apps_success") do
        described_class.import(app_id)
      end
    end

    after do
      subject
    end

    before do
      allow(described_class).to receive(:new).with(app_id).and_return(instance)
    end

    it 'creates an instance' do
      expect(described_class).to receive(:new).with(app_id).and_call_original
    end

    it 'calls import on instance' do
      expect(instance).to receive(:import)
    end
  end

  describe '#import' do
    context 'when app exists' do
      before do
        allow(PrioriData::Repositories::App).to receive(:find).and_return(OpenStruct.new(publisher_id: 51))
      end

      subject { instance.import }

      it 'returns 51' do
        expect(subject).to eq 51
      end

      it 'makes no request to the API' do
        expect(HTTParty).not_to receive(:get)
      end
    end

    context 'when app does not exist' do
      before do
        allow(PrioriData::Repositories::App).to receive(:find).and_return(nil)
      end

      context 'when service is available' do
        context 'and response is success' do
          subject do
            VCR.use_cassette("apple_apps_success") do
              instance.import
            end
          end

          after do
            subject
          end

          it 'makes request to the API' do
            expect(HTTParty).to receive(:get).with("https://itunes.apple.com/lookup", {:query=>{:id=>327193945}}).and_call_original
          end

          it 'maps app' do
            expect(instance).to receive(:map_app)
          end
        end

        context 'and response is failure' do
          subject do
            VCR.use_cassette("apple_apps_failure") do
              instance.import
            end
          end

          it 'raises AppleServiceChangedException' do
            expect{subject}.to raise_error(PrioriData::AppleServiceChangedException)
          end
        end
      end
    end

    context 'when service is not available' do
      subject { instance.import }

      before do
        allow(PrioriData::Repositories::App).to receive(:find).and_return(nil)
        allow(HTTParty).to receive(:get).and_raise(Errno::EHOSTUNREACH)
      end

      it 'raises AppleServiceNotAvailableException' do
        expect{subject}.to raise_error(PrioriData::AppleServiceNotAvailableException)
      end
    end
  end

  describe '#map_app' do
    let(:json) { { "artistId" => 13, "artistName" => 'name' } }
    subject { instance.map_app(json) }

    after do
      subject
    end

    it 'creates the app publisher' do
      expect(PrioriData::Repositories::Publisher).to receive(:persist).with(json)
    end

    it 'creates the app' do
      expect(PrioriData::Repositories::App).to receive(:persist).with(json)
    end
  end
end
