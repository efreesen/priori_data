describe PrioriData::Controllers::Apps do
  let(:instance) { described_class.new(params) }
  
  describe '.show' do
    let(:params) { {} }
    subject { described_class.show(params) }

    before do
      allow(described_class).to receive(:new).and_return(instance)
    end

    after { subject }

    it 'creates an instance' do
      expect(described_class).to receive(:new).with(params)
    end

    it 'calls show on instance' do
      expect(instance).to receive(:show)
    end
  end

  describe '#show' do
    context 'when parameters are valid' do
      let(:category_id) { 5 }
      let(:monetization) { 'paid' }
      let(:rank) { 165 }
      let(:params) do
        {
          category_id: category_id,
          monetization: monetization,
          rank: rank
        }
      end

      subject { instance.show }

      after { subject }

      it 'searches for the desired app' do
        expect(PrioriData::Repositories::Ranking).to receive(:find_app).with(category_id, monetization, rank)
      end

      it 'builds the response' do
        expect(instance).to receive(:response)
      end
    end

    context 'when monetization is invalid' do
      let(:category_id) { 5 }
      let(:monetization) { 'this is an attack!!!!' }
      let(:rank) { 165 }
      let(:response) do
        {
          resource: {},
          error: 'Invalid monetization param, should be one of these: paid, free or grossing'
        }
      end

      let(:params) do
        {
          category_id: category_id,
          monetization: monetization,
          rank: rank
        }
      end

      subject { instance.show }

      after { subject }

      it 'does not search for the app' do
        expect(PrioriData::Repositories::Ranking).not_to receive(:find_app)
      end

      it 'returns an error' do
        expect(subject).to eq response
      end
    end
  end

  describe '#response' do
    let(:params) { {} }

    subject { instance.response }

    context 'when there is no resource' do
      before do
        allow(instance).to receive(:resource).and_return(nil)
        allow(PrioriData::VOs::App).to receive(:hash).and_return({})
      end

      context 'and message is not set' do
        let(:response) do
          {
            resource: {},
            error: "Resource not found."
          }
        end

        before do
          allow(instance).to receive(:message).and_return(nil)
        end

        it 'returns resource not found message' do
          expect(subject).to eq response
        end
      end

      context 'and message is set' do
        let(:response) do
          {
            resource: {},
            error: "message"
          }
        end

        before do
          allow(instance).to receive(:message).and_return('message')
        end

        it 'returns the message' do
          expect(subject).to eq response
        end
      end
    end

    context 'when there is a resource' do
      let(:resource) { 'resource' }
      let(:response) do
        {
          resource: resource,
          error: nil
        }
      end

      before do
        allow(instance).to receive(:resource).and_return(resource)
        allow(PrioriData::VOs::App).to receive(:hash).and_return(resource)
      end

      it 'returns the resource' do
        expect(subject).to eq response
      end
    end
  end
end