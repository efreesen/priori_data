describe PrioriData::Integration::Categories do
  let(:instance) { described_class.new }

  after do
    subject
  end

  describe '.import' do
    subject { described_class.import }

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
end
