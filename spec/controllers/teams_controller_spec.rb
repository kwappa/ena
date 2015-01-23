require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe '#index' do
    subject(:index) { get :index }

    context 'when guest user' do
      specify { expect(index).to be_ok }
    end

    context 'when login user' do
      before { sign_in create(:user) }
      specify { expect(index).to be_ok }
    end
  end
end
