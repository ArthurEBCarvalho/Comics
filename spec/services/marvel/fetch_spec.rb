require 'rails_helper'

RSpec.describe Marvel::Fetch do
  subject { described_class.comics }

  describe '#comics' do
    let(:faraday_response) { Faraday::Response.new(status: status, body: body) }
    let(:url)              { "https://gateway.marvel.com:443/v1/public#{endpoint}" }
    let(:endpoint)         { '/comics' }
    let(:status)           { 200 }
    let(:body)             { { data: { results: results } }.to_json }
    let(:results)          { [] }
    let(:headers) do
      {
        Accept:           'application/json',
        'Content-Type' => 'application/json'
      }
    end
    let(:comics_params) do
      {
        ts:      '1',
        apikey:  ENV['MARVEL_PUBLIC_KEY'],
        hash:    Digest::MD5.hexdigest("1#{ENV['MARVEL_PRIVATE_KEY']}#{ENV['MARVEL_PUBLIC_KEY']}"),
        orderBy: 'focDate',
        limit:   20,
        offset:  0
      }
    end

    before { allow(Faraday).to receive(:get).and_return(faraday_response) }

    it { expect { subject }.not_to raise_exception(Marvel::RequestError) }
    it { is_expected.to eq [] }

    describe 'validate what was run' do
      before { subject }

      it { expect(Faraday).to have_received(:get).with(url, comics_params, headers).once }
    end

    context 'when returns error status' do
      let(:status)        { 500 }
      let(:error_message) { 'Error message' }
      let(:body)          { { 'error' => error_message }.to_json }

      it { expect { subject }.to raise_error(Marvel::RequestError) }
    end

    context 'when has character_name param' do
      subject { described_class.comics(character_name: 'Deadpool') }

      let(:endpoint) { '/characters' }
      let(:results) { [{ id: 1 }] }
      let(:comics_params) do
        {
          ts:         '1',
          apikey:     ENV['MARVEL_PUBLIC_KEY'],
          hash:       Digest::MD5.hexdigest("1#{ENV['MARVEL_PRIVATE_KEY']}#{ENV['MARVEL_PUBLIC_KEY']}"),
          orderBy:    'focDate',
          characters: 1,
          limit:      20,
          offset:     0
        }
      end
      let(:characters_params) do
        {
          ts:      '1',
          apikey:  ENV['MARVEL_PUBLIC_KEY'],
          hash:    Digest::MD5.hexdigest("1#{ENV['MARVEL_PRIVATE_KEY']}#{ENV['MARVEL_PUBLIC_KEY']}"),
          orderBy: 'focDate',
          name:    'Deadpool',
          limit:   1,
          offset:  0
        }
      end

      it { is_expected.to eq [{ 'id' => 1 }] }

      describe 'validate what was run' do
        before { subject }
  
        it { expect(Faraday).to have_received(:get).with("https://gateway.marvel.com:443/v1/public/characters", characters_params, headers).once }
        it { expect(Faraday).to have_received(:get).with("https://gateway.marvel.com:443/v1/public/comics", comics_params, headers).once }
      end
    end

    context 'when has page param' do
      subject { described_class.comics(page: page) }

      let(:comics_params) do
        {
          ts:       '1',
          apikey:   ENV['MARVEL_PUBLIC_KEY'],
          hash:     Digest::MD5.hexdigest("1#{ENV['MARVEL_PRIVATE_KEY']}#{ENV['MARVEL_PUBLIC_KEY']}"),
          orderBy:  'focDate',
          limit:    20,
          offset:   offset
        }
      end

      before { subject }

      context 'when page is 0' do
        let(:page) { '0' }
        let(:offset) { 0 }

        it { expect(Faraday).to have_received(:get).with(url, comics_params, headers).once }
      end

      context 'when page is 0' do
        let(:page) { '1' }
        let(:offset) { 0 }

        it { expect(Faraday).to have_received(:get).with(url, comics_params, headers).once }
      end

      context 'when page is 2 or more' do
        let(:page) { '2' }
        let(:offset) { 20 }

        it { expect(Faraday).to have_received(:get).with(url, comics_params, headers).once }
      end
    end
  end
end
