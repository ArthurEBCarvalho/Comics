require 'rails_helper'
require 'factories/users'
require 'support/devise'

RSpec.describe ComicsController, type: :controller do
  subject { response }

  let(:user) { create(:user) }

  describe 'GET root' do
    login_user

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
end
