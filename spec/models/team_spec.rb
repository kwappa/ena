require 'rails_helper'

RSpec.describe Team, type: :model do
  describe '#active_users' do
    let!(:team)            { create :team }
    let!(:active_user)     { create :user }
    let!(:withdrawn_user)  { create :user }
    let!(:future_user)     { create :user }
    let(:role)             { :member }
    subject(:active_users) { team.active_users }

    before do
      team.assign_member(active_user, role)
      team.assign_member(withdrawn_user, role, Date.yesterday)
      team.withdraw_member(withdrawn_user, role)
      team.assign_member(future_user, role, Date.tomorrow)
    end

    it 'returns only active users' do
      expect(team.users.count).to eq 3
      expect(active_users.all).to match_array [active_user]
    end
  end
end
