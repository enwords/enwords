require 'rails_helper'

describe Api::Public::NamesController, type: :request do
  let(:headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  let(:params) { {} }

  before do
    create(:word, pos: :j, language: :eng)
    create(:word, pos: :i, language: :eng)
    allow_any_instance_of(Sentence::ByWord).to receive(:run!).and_return('')
  end

  context 'GET #random' do
    subject { get '/api/public/names/random', params: params, headers: headers }

    it do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns json' do
      subject
      result = JSON.parse(response.body).deep_symbolize_keys
      expect(result).to be_a(Hash)
      expect(result[:group]).to be_a(String)
      expect(result[:name]).to be_a(String)
    end

    context 'with group' do
      let(:params) { { group: 'zodiac_signs' } }

      it 'returns json' do
        subject
        result = JSON.parse(response.body).deep_symbolize_keys
        expect(result[:group]).to eq('zodiac_signs')
        expect(result[:name]).to be_a(String)
      end
    end
  end
end
