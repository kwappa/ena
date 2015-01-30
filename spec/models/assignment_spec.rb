require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'scope :active' do
    let(:teams) { (0..2).map { create :team } }
    let(:user)  { create :user }
    let(:role)  { :member }

    before do
      Timecop.freeze(Time.local(2015, 1, 30))
      # active
      teams[0].assign_user(user, role)
      # future assignment
      teams[1].assign_user(user, role, Date.tomorrow)
      # withdrawn assignment
      teams[2].assign_user(user, role, Date.yesterday)
      teams[2].withdraw_user(user, role)
    end

    it 'returns only active assignment' do
      expect(user.assignments.active).to match_array teams[0].assignments
    end

    after { Timecop.return }
  end
end
