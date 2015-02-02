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

    shared_examples 'assignable to team' do |operator_role, target_role|
      before { team.assign_user(user, operator_role) }
      it "#{operator_role} can assign #{target_role}" do
        expect(team.assignable?(user, target_role)).to be true
      end
    end

    shared_examples 'does not assignable to team' do |operator_role, target_role|
      before { team.assign_user(user, operator_role) }
      it "#{operator_role} can not assign #{target_role}" do
        expect(team.assignable?(user, target_role)).to be false
      end
    end

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

    context 'when assigned as a :director' do
      [:manager, :leader, :member].each do |target_role|
        include_examples 'assignable to team', :director, target_role
      end
      include_examples 'does not assignable to team', :director, :director
    end

    context 'when assigned as a :manager' do
      [:leader, :member].each do |target_role|
        include_examples 'assignable to team', :manager, target_role
      end
      [:manager, :director].each do |target_role|
        include_examples 'does not assignable to team', :manager, target_role
      end
    end

    context 'when assigned as a :leader' do
      include_examples 'assignable to team', :leader, :member
      [:manager, :director, :manager].each do |target_role|
        include_examples 'does not assignable to team', :leader, target_role
      end
    end

    context 'when assigned as a :member' do
      [:manager, :director, :manager, :member].each do |target_role|
        include_examples 'does not assignable to team', :member, target_role
      end
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

  describe '#withdraw_user' do
    let!(:team) { create :team }
    let!(:user) { create :user }
    let(:role)  { :member }
    subject(:withdraw) { team.withdraw_user(user, role) }

    context 'when user does not assigned to team' do
      specify { expect { subject }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'when user assigned to team' do
      let(:assign) do
        Assignment.where(team_id: team.id, user_id: user.id, role_id: ::Role.id(role)).first
      end

      before { Timecop.freeze(Time.local(2015, 1, 30)) }

      it 'withdraw user from team' do
        team.assign_user(user, role)
        expect(assign.withdrawn_on).to be_nil
        withdraw
        assign.reload
        expect(assign.withdrawn_on).to eq Date.today
      end

      after { Timecop.return }
    end
  end

  describe '#members' do
    let!(:team)             { create :team }
    let!(:director)         { create :user }
    let!(:manager)          { create :user }
    let!(:leader)           { create :user }
    let!(:member)           { create :user }
    let!(:other_member)     { create :user }
    let!(:withdrawn_member) { create :user }
    let(:expected_members) do
      {
        director: [director],
        manager:  [manager],
        leader:   [leader],
        member:   [member, other_member],
      }
    end

    before do
      team.assign_user(director,           :director)
      team.assign_user(manager,            :manager)
      team.assign_user(leader,             :leader)
      team.assign_user(member,             :member)
      team.assign_user(other_member,       :member)
      team.assign_user(withdrawn_member,   :member, Date.yesterday)
      team.withdraw_user(withdrawn_member, :member)
    end

    it 'returns correlct list of members' do
      expect(team.members).to eq expected_members
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
