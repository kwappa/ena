require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe '#index' do
    subject(:index) { get :index }

    describe 'access control' do
      context 'when guest user' do
        specify { expect(index).to be_ok }
      end

      context 'when login user' do
        before { sign_in create(:user) }
        specify { expect(index).to be_ok }
      end
    end

    describe 'list of teams' do
      let!(:teams) { [create(:team), create(:team)] }
      before { index }
      specify { expect(assigns[:teams]).to match_array teams }
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
        expect(subject).to redirect_to team_path(Team.last)
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

  describe '#update' do
    let(:team_id)          { 0 }
    let(:team_name)        { '' }
    let(:team_description) { '' }
    let(:team_params)      { { id: team_id, name: team_name, description: team_description } }
    let(:team)             { create(:team) }
    subject(:update)       { patch :update, id: team_id, team: team_params }

    context 'when team does not exist' do
      before { update }
      it 'stores error message and redirect' do
        expect(flash[:error]).to be_present
        expect(response).to redirect_to teams_path
      end
    end

    context 'when team exist' do
      let(:team_id) { team.id }

      context 'with valid data' do
        let(:team_name) { 'new team name' }
        let(:old_team_name) { team.name }
        it 'updates team name' do
          expect { update }.to change { team.reload.name }.from(old_team_name).to(team_name)
          expect(response).to redirect_to team_path(team)
        end
      end

      context 'with invalid data' do
        before { update }
        it 'stores error message and redirect' do
          expect(flash[:error]).to be_present
          expect(response).to redirect_to edit_team_path(team)
        end
      end
    end
  end
end
