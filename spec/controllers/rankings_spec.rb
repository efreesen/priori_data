describe PrioriData::Controllers::Rankings do
  let(:instance) { described_class.new(params) }
  
  describe '.index' do
    let(:params) { {} }
    subject { described_class.index(params) }

    before do
      allow(described_class).to receive(:new).and_return(instance)
    end

    after { subject }

    it 'creates an instance' do
      expect(described_class).to receive(:new).with(params)
    end

    it 'calls index on instance' do
      expect(instance).to receive(:index)
    end
  end

  describe '#index' do
    context 'when parameters are valid' do
      let(:category_id) { 5 }
      let(:monetization) { 'paid' }
      let(:params) do
        {
          category_id: category_id,
          monetization: monetization
        }
      end

      subject { instance.index }

      after { subject }

      it 'searches for the desired ranking' do
        expect(PrioriData::Repositories::Ranking).to receive(:find_ranking).with(category_id, monetization).and_return([])
      end

      it 'builds the response' do
        expect(instance).to receive(:response)
      end
    end

    context 'when monetization is invalid' do
      let(:category_id) { 5 }
      let(:monetization) { 'this is an attack!!!!' }
      let(:response) do
        {
          resources: [],
          error: 'Invalid monetization param, should be one of these: paid, free or grossing'
        }
      end

      let(:params) do
        {
          category_id: category_id,
          monetization: monetization
        }
      end

      subject { instance.index }

      after { subject }

      it 'does not search for the ranking' do
        expect(PrioriData::Repositories::Ranking).not_to receive(:find_ranking)
      end

      it 'returns an error' do
        expect(subject).to eq response
      end
    end
  end

  describe '#response' do
    let(:params) { {} }

    subject { instance.response }

    context 'when there is no resources' do
      before do
        allow(instance).to receive(:resources).and_return([])
        allow(PrioriData::VOs::App).to receive(:hash).and_return({})
      end

      context 'and message is not set' do
        let(:response) do
          {
            resources: [],
            error: "Resources not found."
          }
        end

        before do
          allow(instance).to receive(:message).and_return(nil)
        end

        it 'returns resources not found message' do
          expect(subject).to eq response
        end
      end

      context 'and message is set' do
        let(:response) do
          {
            resources: [],
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

    context 'when there are resources' do
      let(:resources) { ['resources'] }
      let(:response) do
        {
          resources: resources,
          error: nil
        }
      end

      before do
        allow(instance).to receive(:resources).and_return(resources)
        allow(PrioriData::VOs::Ranking).to receive(:hash).and_return(resources)
      end

      it 'returns the resources' do
        expect(subject).to eq response
      end
    end
  end
end
