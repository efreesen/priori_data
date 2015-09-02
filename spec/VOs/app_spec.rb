describe PrioriData::VOs::App do
  describe '.hash' do
    subject { described_class.hash(resource) }

    context 'when there is a resource' do
      let(:publisher) { OpenStruct.new(name: 'publisher_name') }
      let(:resource) { OpenStruct.new(params) }
      let(:params) do
        {
          name: 'name',
          description: 'description',
          small_icon_url: 'small_icon_url',
          publisher: publisher,
          price: 2.5,
          version: 'version_number',
          average_user_rating: 3.6
        }
      end

      let(:result) do
        {
          name: "name",
          description: "description",
          small_icon_url: "small_icon_url",
          publisher_name: "publisher_name",
          price: "2.50",
          version_number: 'version_number',
          average_user_rating: "3.60"
        }
      end

      it 'returns a hash with app parameters' do
        expect(subject).to eq(result)
      end
    end

    context 'when resource is nil' do
      let(:resource) { nil }

      it 'returns an empty hash' do
        expect(subject).to eq({})
      end
    end

    context 'when resource is empty' do
      let(:resource) { {} }

      it 'returns an empty hash' do
        expect(subject).to eq({})
      end
    end
  end
end
