require 'rails_helper'

RSpec.describe Role do
  describe '.id' do
    subject(:role_id) { described_class.id(role_name) }

    context 'with valid role name' do
      context ':member' do
        let(:role_name) { :member }
        it 'returns role id by name' do
          expect(role_id).to eq 0
        end
      end

      context ':leader' do
        let(:role_name) { :leader }
        it 'returns role id by name' do
          expect(role_id).to eq 1
        end
      end
    end

    context 'with invalid role name' do
      let(:role_name) { 'INVALID_ROLE_NAME' }
      specify { expect { role_id }.to raise_error ArgumentError }
    end
  end

  describe '.name' do
    subject(:role_name) { described_class.name(role_id) }
    context 'when director' do
      let(:role_id) { 3 }
      specify { expect(role_name).to eq :director }
    end

    context 'when invalid id' do
      let(:role_id) { 999999 }
      specify { expect { role_name }.to raise_error ArgumentError }
    end
  end

  describe '.permissions' do
    subject(:permissions) { described_class.permissions(action, role) }
    context 'when action is inavlid' do
      let(:action) { 'INVALID_ACTION' }
      let(:role)   { :member }
      specify { expect { permissions }.to raise_error ArgumentError }
    end

    context 'when action is valid but role is invalid' do
      let(:action) { :team_assign }
      let(:role)   { 'INVALID_ROLE' }
      specify { expect { permissions }.to raise_error ArgumentError }
    end

    context 'when action and role are valid' do
      let(:action) { :team_assign }
      let(:role)   { :director }
      specify { expect(permissions).to match_array [:member, :leader, :manager] }
    end
  end
end

RSpec.describe Team, type: :model do
  describe '#assignable?' do
    let!(:team) { create :team }
    let!(:user) { create :user }
    subject(:assignable?) { team.assignable?(user, role) }

    context 'when administrator' do
      let(:role) { :director }
      before  { user.authorize(:administration) }
      specify { expect(assignable?).to be true }
    end

    context 'when director but not a member' do
      let(:role) { :member }
      before { user.authorize(:direction) }
      specify { expect(assignable?).to be false }
    end
  end

  describe '#assign_user' do
    let!(:team) { create :team }
    let!(:user) { create :user }
    let(:role)  { :member }
    subject(:assign) { team.assign_user(user, role) }

    it 'assigns user to team' do
      expect(user.teams).to be_empty
      expect(team.users).to be_empty
      assign
      expect(user.teams).to be_include(team)
      expect(team.users).to be_include(user)
    end
  end
end

RSpec.describe User, type: :model do
  let!(:user) { create :user }

  describe '#roles' do
    let!(:team) { create :team }
    subject(:roles) { user.roles(team) }

    context 'without assignments to specified team' do
      let!(:another_team) { create :team }
      before { another_team.assign_user(user, :member) }
      it 'retruns no roles' do
        expect(roles).to match_array []
        expect(Assignment.where(user_id: user.id, team_id: another_team.id)).to be_present
      end
    end

    context 'with assignments' do
      context 'assigned only as a :member' do
        before { team.assign_user(user, :member) }
        specify { expect(roles).to match_array [:member] }
      end

      context 'assigned as :leader and :manager' do
        before do
          team.assign_user(user, :leader)
          team.assign_user(user, :manager)
        end
        specify { expect(roles).to match_array [:leader, :manager] }
      end
    end
  end
end
