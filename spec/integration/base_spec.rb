describe PrioriData::Integration::Base do
  let(:instance) { described_class.new }

  describe '.load!' do
    subject { described_class.load! }

    before do
      allow(described_class).to receive(:new).and_return(instance)
    end

    after do
      subject
    end

    it 'creates an instance' do
      expect(described_class).to receive(:new).and_call_original
    end

    it 'calls load on instance' do
      expect(instance).to receive(:load!)
    end
  end

  describe '#load!' do
    subject { instance.load! }

    after do
      subject
    end

    context 'when there is no data loaded on db' do
      it 'loads all the categories' do
        expect(instance).to receive(:load_categories)
      end
    end
  end
end
