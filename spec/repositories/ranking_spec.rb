describe PrioriData::Repositories::Ranking do
  let(:instance) { described_class.new(category_id, monetization, rank, app_id, publisher_id) }
  let(:model) { Ranking.new }
  let(:category_id) { 6001 }
  let(:monetization) { :grossing }
  let(:rank) { 25 }
  let(:app_id) { 327193945 }
  let(:publisher_id) { 303585709 }
  let(:attributes) { { category_id: category_id, monetization: monetization, rank: rank, app_id: app_id, publisher_id: publisher_id } }

  describe '.persist' do    
    subject { described_class.persist(category_id, monetization, rank, app_id, publisher_id) }

    before do
      allow(described_class).to receive(:new).and_return(instance)
    end

    after do
      subject
    end

    it 'creates an instance' do
      expect(described_class).to receive(:new).with(category_id, monetization, rank, app_id, publisher_id)
    end

    it 'calls persist on instance' do
      expect(instance).to receive(:persist)
    end
  end

  describe '#persist' do
    subject { instance.persist }

    before do
      allow(Ranking).to receive(:first_or_initialize).and_return(model)
    end

    after do
      subject
    end

    it 'searches for existing category with same id' do
      expect(Ranking).to receive(:where).with(category_id: category_id, monetization: monetization, rank: rank).and_call_original
    end

    it 'creates ranking or updates it`s attributes' do
      expect(model).to receive(:update_attributes).with(attributes)
    end
  end

  describe '#validate_args' do
    # Category_id
    context 'when category_id is not passed' do
      subject { described_class.new().validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when category_id is nil' do
      subject { described_class.new(nil).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when category_id is neither String or Fixnum' do
      subject { described_class.new({}).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    # Monetization
    context 'when monetization is not passed' do
      subject { described_class.new(13).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when monetization is not in the accepted list' do
      subject { described_class.new(13, :invalid).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    # Rank
    context 'when rank is not passed' do
      subject { described_class.new(13, :free).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when rank is not Fixnum' do
      subject { described_class.new(13, :free, 'invalid').validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    # AppId
    context 'when app_id is not passed' do
      subject { described_class.new(13, :free, 13).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when app_id is neither String or Fixnum' do
      subject { described_class.new(13, :free, 13, []).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    # PublisherId
    context 'when app_id is not passed' do
      subject { described_class.new(13, :free, 13, 13).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end

    context 'when app_id is neither String or Fixnum' do
      subject { described_class.new(13, :free, 13, 13, {}).validate_args }

      it 'raises ArgumentError' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end
  end

  describe ".find_app" do
    let(:app) { App.new }
    let(:category_id) { 1 }
    let(:monetization) { 'free' }
    let(:rank) { 14 }

    subject do
      described_class.find_app(category_id, monetization, rank)
    end

    after { subject }

    context 'when apps are found' do
      before do
        result = [OpenStruct.new(app: app)]

        allow(Ranking).to receive(:limit).and_return(result)
      end

      it 'eagerly loads the app and the publisher' do
        expect(Ranking).to receive(:eager_load).with([:app, :publisher]).and_call_original
      end

      it 'searches for the app' do
        expect(Ranking).to receive(:where).with(category_id: category_id, monetization: monetization, rank: rank).and_call_original
      end

      it 'limits the result set to one result' do
        expect(Ranking).to receive(:limit).with(1).and_call_original
      end

      it 'returns the found app' do
        expect(subject).to eq app
      end
    end

    context 'when no apps are found' do
      before do
        allow(Ranking).to receive(:limit).and_return([])
      end

      it 'eagerly loads the app and the publisher' do
        expect(Ranking).to receive(:eager_load).with([:app, :publisher]).and_call_original
      end

      it 'searches for the app' do
        expect(Ranking).to receive(:where).with(category_id: category_id, monetization: monetization, rank: rank).and_call_original
      end

      it 'limits the result set to one result' do
        expect(Ranking).to receive(:limit).with(1).and_call_original
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe ".find_ranking" do
    let(:ranking) { Ranking.new }
    let(:category_id) { 1 }
    let(:monetization) { 'free' }

    subject do
      described_class.find_ranking(category_id, monetization)
    end

    after { subject }

    context 'when rankings are found' do
      before do
        allow(Ranking).to receive(:where).and_return([ranking])
      end

      it 'eagerly loads the ranking and the publisher' do
        expect(Ranking).to receive(:eager_load).with(:app).and_call_original
      end

      it 'searches for the ranking' do
        expect(Ranking).to receive(:where).with(category_id: category_id, monetization: monetization).and_call_original
      end

      it 'returns the found ranking' do
        expect(subject).to eq [ranking]
      end
    end

    context 'when no rankings are found' do
      before do
        allow(Ranking).to receive(:where).and_return([])
      end

      it 'eagerly loads the ranking and the publisher' do
        expect(Ranking).to receive(:eager_load).with(:app).and_call_original
      end

      it 'searches for the ranking' do
        expect(Ranking).to receive(:where).with(category_id: category_id, monetization: monetization).and_call_original
      end

      it 'returns an empty result set' do
        expect(subject).to be_empty
      end
    end
  end
end
