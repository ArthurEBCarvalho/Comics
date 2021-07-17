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
      it { expect(Marvel::Fetch).to have_received(:comics) }
    end

    context 'when has param' do
      before { get :index, params: { character: :Deadpool } }

      it { is_expected.to have_http_status(:success) }
      it { expect(Marvel::Fetch).to have_received(:comics).with('Deadpool') }
    end
  end
end
