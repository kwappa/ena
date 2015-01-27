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
  end
end
