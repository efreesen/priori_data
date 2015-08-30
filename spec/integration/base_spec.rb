describe PrioriData::Integration::Base do
  describe '.load!' do
    let(:instance) { described_class.new }

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
end
