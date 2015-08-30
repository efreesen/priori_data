describe PrioriData::Integration::Base do
  let(:instance) { described_class.new }

  after do
    subject
  end

  describe '.load!' do
    subject { described_class.load! }

    before do
      allow(described_class).to receive(:new).and_return(instance)
    end

    it 'creates an instance' do
      expect(described_class).to receive(:new).and_call_original
    end

    it 'calls load! on instance' do
      expect(instance).to receive(:load!)
    end
  end

  describe '#load!' do
    subject { instance.load! }

    it 'loads all the categories' do
      expect(instance).to receive(:load_categories)
    end
  end

  describe '#load_categories' do
    subject { instance.load_categories }

    it 'calls import on Categories' do
      expect(PrioriData::Integration::Categories).to receive(:import)
    end
  end
end
