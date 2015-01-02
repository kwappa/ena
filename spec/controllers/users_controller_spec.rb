require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe '#index' do
    subject(:index) { get :index }
    context 'when user does not login' do
      it { expect(index).to be_ok }
    end

    context 'when user login' do
      before { sign_in user }
      it { expect(index).to redirect_to home_path(user.nick) }
    end
  end
end
