describe PrioriData::Repositories::Category do
  describe '.persist' do
    context 'when id is not passed' do
      subject { described_class.persist }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when id is not String or Fixnum' do
      subject { described_class.persist([1]) }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when params are not passed' do
      subject { described_class.persist(13) }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when params are nil' do
      subject { described_class.persist(13, nil) }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when params are empty' do
      subject { described_class.persist(13, {}) }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when all args are passed' do
      let(:category) { Category.new }
      let(:attributes) { {name: 'test'} }

      subject { described_class.persist(13, attributes) }

      before do
        allow(Category).to receive(:first_or_initialize).and_return(category)
      end

      after do
        subject
      end

      it 'searches for existing category with same id' do
        expect(Category).to receive(:where).with(id: 13).and_call_original
      end

      it 'creates category or updates it`s attributes' do
        expect(category).to receive(:update_attributes).with(attributes)
      end
    end
  end
end
