describe PrioriData::VOs::Publisher do
  describe '.hash' do
    subject { described_class.hash(resources) }

    context 'when there is a resource' do
      let(:publisher) { OpenStruct.new(name: 'publisher_name') }
      let(:resources) { ['first_publisher', 'second_publisher'] }
      let(:result) do
        [
          { rank:1, publisher:"first_publisher" },
          { rank:2, publisher:"second_publisher" }
        ]
      end

      before do
        allow(described_class).to receive(:grouped_resources).and_return(resources)
      end

      it 'returns a hash with app parameters' do
        expect(subject).to eq(result)
      end
    end

    context 'when resource is nil' do
      let(:resources) { nil }

      it 'returns an empty hash' do
        expect(subject).to eq([])
      end
    end

    context 'when resource is empty' do
      let(:resources) { [] }

      it 'returns an empty hash' do
        expect(subject).to eq([])
      end
    end
  end

  describe '.grouped_resources' do
    subject { described_class.grouped_resources(resources) }

    context 'when resources is empty' do
      let(:resources) { [] }

      it 'returns an empty array' do
        expect(subject).to eq []
      end
    end

    context 'when resources have elements' do
      let(:first_attributes) { { name: 'first', number_of_apps: 16 } }
      let(:second_attributes) { { name: 'second', number_of_apps: 11 } }
      let(:last_attributes) { { name: 'last', number_of_apps: 5 } }
      let(:result) { [first_attributes, second_attributes, last_attributes] }
      let(:resources) do
        20.times.map do |i|
          OpenStruct.new(publisher_id: ((i % 3) + 1), name: "name_#{i+1}")
        end
      end

      before do
        allow(described_class).to receive(:attributes).with(1, anything).and_return(second_attributes)
        allow(described_class).to receive(:attributes).with(2, anything).and_return(first_attributes)
        allow(described_class).to receive(:attributes).with(3, anything).and_return(last_attributes)
      end

      it 'returns a sorted hash' do
        expect(subject).to eq result
      end
    end
  end

  describe '.attributes' do
    let(:result) do
      {
        publisher_id:12,
        publisher_name: "PublisherName",
        number_of_apps: 10,
        app_names: ["app_1", "app_2", "app_3", "app_4", "app_5", "app_6", "app_7", "app_8", "app_9", "app_10"
          ]
      }
    end

    let(:apps) do
      10.times.map do |i|
        OpenStruct.new(
          publisher: OpenStruct.new(name: 'PublisherName'),
          app: OpenStruct.new(name: "app_#{i+1}")
        )
      end
    end

    subject { described_class.attributes(12, apps) }

    it 'returns an attributes hash' do
      expect(subject).to eq result
    end
  end
end
