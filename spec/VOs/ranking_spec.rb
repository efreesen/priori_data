describe PrioriData::VOs::Ranking do
  describe '.hash' do
    subject { described_class.hash(resources) }

    context 'when there is a resource' do
      let(:publisher) { OpenStruct.new(name: 'publisher_name') }
      let(:resources) { params.map { |param| OpenStruct.new(param) } }
      let(:params) do
        [
          {
            rank: 1,
            app: 'first_app'
          },
          {
            rank: 2,
            app: 'second_app'
          }
        ]
      end

      let(:result) do
        [ { rank: 1, app: "mocked" }, { rank: 2, app: "mocked" } ]
      end

      before do
        allow(PrioriData::VOs::App).to receive(:hash).and_return('mocked')
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
end
