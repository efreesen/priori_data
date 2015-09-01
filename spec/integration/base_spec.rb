describe PrioriData::Integration::Base do
  let(:instance) { described_class.new }

  after do
    subject
  end

  describe '.load!' do
    subject do
      VCR.use_cassette("apple_categories_success") do
        described_class.load!
      end
    end

    before do
      allow(described_class).to receive(:new).and_return(instance)
      allow(Category).to receive(:all).and_return([])
    end

    it 'creates an instance' do
      expect(described_class).to receive(:new).and_call_original
    end

    it 'calls load! on instance' do
      expect(instance).to receive(:load!)
    end
  end

  describe '#load!' do
    subject do
      VCR.use_cassette("apple_categories_success") do
        instance.load!
      end
    end

    before do
      allow(Category).to receive(:all).and_return([])
    end

    it 'loads all the categories' do
      expect(instance).to receive(:load_categories)
    end

    it 'loads rankings for all categories' do
      expect(instance).to receive(:load_rankings)
    end
  end

  describe '#load_categories' do
    subject do
      VCR.use_cassette("apple_categories_success") do
        instance.load_categories
      end
    end

    it 'calls import on Categories' do
      expect(PrioriData::Integration::Categories).to receive(:import)
    end
  end

  describe '#load_rankings' do
    let(:pool) { double }
    let(:categories) do
      result = []

      10.times do |i|
        result.push OpenStruct.new(id: i)
      end

      result
    end

    before do
      allow(Category).to receive(:all).and_return(categories)
      allow(PrioriData::Integration::Rankings).to receive(:pool).and_return(pool)
      allow(pool).to receive(:future)
    end

    after do
      subject
    end

    subject { described_class.new.load_rankings }

    it 'creates rankings for all categories' do
      expect(pool).to receive(:future).with(:import, anything).exactly(10)
    end

    context 'when service is not available' do
      before do
        allow_any_instance_of(PrioriData::Integration::Rankings).to receive(:import).and_raise(PrioriData::AppleServiceNotAvailableException)
      end

      it 'keeps trying to create other rankings' do
        expect(pool).to receive(:future).with(:import, anything).exactly(10)
      end
    end

    context 'when service returns a failure' do
      before do
        allow_any_instance_of(PrioriData::Integration::Rankings).to receive(:import).and_raise(PrioriData::AppleServiceChangedException)
      end

      it 'keeps trying to create other rankings' do
        expect(pool).to receive(:future).with(:import, anything).exactly(10)
      end
    end
  end

  describe '.http_exceptions' do
    let(:exceptions) do
      [
        Timeout::Error, Errno::EINVAL, Errno::ECONNRESET,
        Errno::EHOSTUNREACH,Errno::ECONNREFUSED, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
        Errno::ETIMEDOUT
      ]
    end

    subject { described_class.http_exceptions }

    it 'returns all HTTP related exceptions' do
      expect(subject).to eq(exceptions)
    end
  end
end
