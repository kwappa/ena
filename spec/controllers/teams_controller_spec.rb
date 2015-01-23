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

  describe '#create' do
    let(:team_params) { { name: '', description: '' } }
    subject(:create) { post :create, team: team_params }

    context 'when name is blank' do
      specify { expect(create).to redirect_to new_team_path }
    end

    context 'when name is specified' do
      let(:team_params) { { name: 'new team' } }

      it 'creates new team' do
        expect { subject }.to change { Team.count }.from(0).to(1)
      end
      it 'redirect to #index' do
        expect(subject).to redirect_to teams_path
      end
    end
  end

  describe '#edit' do
    let(:team_id)  { 0 }
    let(:team)     { create(:team) }
    subject(:edit) { get :edit, id: team_id }

    context 'when team does not exist' do
      before { edit }
      it 'stores error message and redirect' do
        expect(flash[:error]).to be_present
        expect(response).to redirect_to teams_path
      end
    end

    context 'when team exist' do
      let!(:team_id) { team.id }
      before { edit }
      it 'shows edit page' do
        expect(response).to be_ok
        expect(assigns[:team]).to eq team
      end
    end
  end
end
