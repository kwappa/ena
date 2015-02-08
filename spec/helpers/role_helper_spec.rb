require 'rails_helper'

describe RoleHelper do
  describe '.candidate_roles' do
    let!(:candidate_member) { create :user }
    let!(:team)             { create :team }
    let!(:operator)         { create :user }
    subject(:candidate_roles) { helper.candidate_roles(team, operator, candidate_member) }

    context 'when operator is admin' do
      before { operator.authorize(:administration) }
      specify { expect(candidate_roles).to eq [:director, :manager, :leader, :member] }
    end

    context 'when operator is manager of team' do
      before { team.assign_member(operator, :manager) }
      specify { expect(candidate_roles).to eq [:leader, :member] }
    end

    context 'when operator is director of team, candidate user is alredy assigned as a leader' do
      before do
        team.assign_member(operator, :director)
        team.assign_member(candidate_member, :leader)
      end
      specify { expect(candidate_roles).to eq [:manager, :member] }
    end
  end
end
