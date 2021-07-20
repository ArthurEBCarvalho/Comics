require 'rails_helper'

RSpec.describe ComicsController, type: :controller do
  subject { response }

  let(:user) { create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe 'GET root' do
    before { allow(Marvel::Fetch).to receive(:comics) }

    context 'when has not param' do
      before { get :index }
  
      it { is_expected.to have_http_status(:success) }
      it { expect(Marvel::Fetch).to have_received(:comics).with({}) }
    end

    context 'when has character param' do
      before { get :index, params: { character: :Deadpool } }

      it { is_expected.to have_http_status(:success) }
      it { expect(Marvel::Fetch).to have_received(:comics).with(character_name: 'Deadpool') }
    end

    context 'when has page param' do
      before { get :index, params: { page: page } }

      (1..3).each do |page|
        context "when has page #{page}" do
          let(:page) { page }
  
          it { is_expected.to have_http_status(:success) }
          it { expect(Marvel::Fetch).to have_received(:comics).with(page: page.to_s) }
        end
      end
    end

    context 'when has both params' do
      before { get :index, params: { character: :Deadpool, page: '2' } }

      it { is_expected.to have_http_status(:success) }
      it { expect(Marvel::Fetch).to have_received(:comics).with(character_name: 'Deadpool', page: '2') }
    end
  end

  describe 'GET /add_favorite' do
    let(:comic_id) { 1 }

    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
      get :add_favorite, params: { comic_id: comic_id }
    end

    it { is_expected.to have_http_status(:success) }
    it { expect(user.reload.favorite_comics_ids).to eq [1] }
    
    context 'when user already has the comic_id as a favorite' do
      let(:user) { create(:user, favorite_comics_ids: [1]) }

      it { is_expected.to have_http_status(:not_acceptable) }
      it { expect(response.body).to eq({ 'message' => 'You already has this comic as a favorite' }.to_json) }
      it { expect(user.reload.favorite_comics_ids).to eq [1] }
    end

    context 'when has not param comic_id' do
      let(:comic_id) { nil }

      it { is_expected.to have_http_status(:not_acceptable) }
      it { expect(response.body).to eq({ 'message' => 'Param comic_id is required' }.to_json) }
      it { expect(user.reload.favorite_comics_ids).to be_empty }
    end
  end

  describe 'GET /remove_favorite' do
    let(:user) { create(:user, favorite_comics_ids: [1]) }
    let(:comic_id) { 1 }

    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
      get :remove_favorite, params: { comic_id: comic_id }
    end

    it { is_expected.to have_http_status(:no_content) }
    it { expect(user.reload.favorite_comics_ids).to be_empty }

    context 'when user has not comic_id as favorite' do
      let(:comic_id) { 2 }

      it { is_expected.to have_http_status(:not_acceptable) }
      it { expect(response.body).to eq({ 'message' => 'You has not this comic as a favorite' }.to_json) }
      it { expect(user.reload.favorite_comics_ids).to eq [1] }
    end

    context 'when has not param comic_id' do
      let(:comic_id) { nil }

      it { is_expected.to have_http_status(:not_acceptable) }
      it { expect(response.body).to eq({ 'message' => 'Param comic_id is required' }.to_json) }
      it { expect(user.reload.favorite_comics_ids).to eq [1] }
    end
  end
end
