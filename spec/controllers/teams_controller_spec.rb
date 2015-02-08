require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:user) { create :user }

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
    subject(:create_team) { post :create, team: team_params }
    before do
      user.authorize(:administration)
      sign_in user
    end

    context 'when name is blank' do
      specify { expect(create_team).to redirect_to new_team_path }
    end

    context 'when name is specified' do
      let(:team_params) { { name: 'new team' } }

      it 'creates new team' do
        expect { create_team }.to change { Team.count }.from(0).to(1)
      end

      it 'redirect to #index' do
        expect(create_team).to redirect_to team_path(Team.last)
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

    shared_examples 'updates description of team' do
      let(:team_name) { 'test team' }
      let(:team_description) { 'this is an awsome team first ever!' }
      let(:old_team_description) { team.description }
      it 'updates description of team' do
        expect { update }.to change { team.reload.description }.from(old_team_description).to(team_description)
        expect(response).to redirect_to team_path(team)
      end
    end

    context 'when team does not exist' do
      before do
        sign_in create(:user)
        update
      end

      it 'stores error message and redirect' do
        expect(flash[:error]).to be_present
        expect(response).to redirect_to teams_path
      end
    end

    context 'when team exist' do
      let(:team_id) { team.id }

      context 'when user does not logging in' do
        specify { expect(update).to redirect_to new_user_session_path }
      end

      context 'when user logging in' do
        let!(:user) { create :user }
        before { sign_in user }

        context 'as a guest' do
          specify { expect(update).to redirect_to team_path(team) }
        end

        context 'as an administrator' do
          before { user.authorize(:administration) }

          context 'with valid data' do
            include_examples 'updates description of team'
          end

          context 'with invalid data' do
            before { update }
            it 'stores error message and redirect' do
              expect(flash[:error]).to be_present
              expect(response).to redirect_to edit_team_path(team)
            end
          end
        end

        context 'as a member of this team' do
          before { team.assign_member(user, :member) }
          include_examples 'updates description of team'
        end
      end
    end
  end

  describe '#new' do
    subject(:new) { get :new }

    context 'when guest user' do
      specify { expect(new).to redirect_to teams_path }
    end

    context 'when not-permitted user' do
      before { sign_in user }
      specify { expect(new).to redirect_to teams_path }
    end

    context 'when permitted user' do
      before do
        user.authorize(:direction)
        sign_in user
      end

      specify { expect(new).to be_ok }
    end
  end

  describe '#search_candidate_member' do
    let!(:team) { create :team }
    let!(:user) { create :user }
    let!(:alice) { create :user, nick: 'nick_alice', name: 'alice' }
    let(:team_id) { team.id }
    let(:name_or_nick) { nil }
    let(:params) { { team_id: team_id, name_or_nick: name_or_nick } }
    subject(:search_candidate_member) { post :search_candidate_member, params }

    context 'when guest user' do
      specify { expect(search_candidate_member).to redirect_to(new_user_session_path) }
    end

    context 'when login user' do
      before { sign_in user }

      context 'with invalid team id' do
        let(:team_id) { 9999 }
        specify { expect(search_candidate_member).to redirect_to(teams_path) }
      end

      context 'when not authorized' do
        specify { expect(search_candidate_member).to redirect_to(team_path(team)) }
      end

      context 'when administrator' do
        before { user.authorize(:administration) }

        context 'without search keyword' do
          specify { expect(search_candidate_member).to redirect_to(team_path(team)) }
        end

        context 'with search keyword but no result' do
          let(:name_or_nick) { 'INVALID_NAME_OR_NICK' }
          specify { expect(search_candidate_member).to redirect_to(team_path(team)) }
        end

        context 'with search result' do
          let(:name_or_nick) { 'alice' }
          specify { expect(search_candidate_member).to be_ok }
        end
      end

      context 'when director of this team' do
        before { team.assign_member(user, :director) }
        let(:name_or_nick) { 'alice' }
        specify { expect(search_candidate_member).to be_ok }
      end

      context 'when member of this team' do
        before { team.assign_member(user, :member) }
        let(:name_or_nick) { 'alice' }
        specify { expect(search_candidate_member).to redirect_to(team_path(team)) }
      end
    end
  end

  describe '#assign_member' do
    let!(:team) { create :team }
    let!(:operator) { create :user }
    let!(:candidate_member) { create :user }
    let(:team_id) { team.id }
    let(:operator_id) { operator.id }
    let(:candidate_member_id) { candidate_member.id }
    let(:role) { :member }
    let(:params) do
      {
        team_id: team_id,
        operator_id: operator_id,
        candidate_member_id: candidate_member_id,
        role: role,
      }
    end
    subject(:assign_member) { post :assign_member, params }

    shared_examples 'failed to assign member' do
      it 'failed to assign member' do
        expect(assign_member).to redirect_to teams_path
      end
    end

    context 'when team does not fooud' do
      let(:team_id) { 0 }
      include_examples 'failed to assign member'
    end

    context 'when operator does not fooud' do
      let(:operator_id) { 0 }
      include_examples 'failed to assign member'
    end

    context 'when candidate member does not fooud' do
      let(:candidate_member_id) { 0 }
      include_examples 'failed to assign member'
    end

    context 'when operator can not assign member' do
      include_examples 'failed to assign member'
    end

    context 'when operator can assign member' do
      before { team.assign_member(operator, :director) }
      it 'assigns candidate member to team' do
        expect { assign_member }
          .to change { team.members[role].include?(candidate_member) }.from(false).to(true)
      end
      specify { expect(assign_member).to redirect_to team_path(team) }
    end
  end
end
