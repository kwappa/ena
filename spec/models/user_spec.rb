require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    subject(:user) { build(:user, attr) }

    describe 'name' do
      let(:attr) { {} }
      context 'when default' do
        it { expect(user).to be_valid }
      end

      context 'when blank' do
        let(:attr) { { name: ''} }
        it { expect(user).to_not be_valid }
      end

      context 'with valid character' do
        let(:attr) { { name: 'name-NAME_123' } }
        it { expect(user).to be_valid }
      end

      context 'with invalid character' do
        context 'when includes blank' do
          let(:attr) { { name: 'with blank' } }
          it { expect(user).to_not be_valid }
        end

        context 'when includes non-ASCII' do
          let(:attr) { { name: 'user_ユーザ_name' } }
          it { expect(user).to_not be_valid }
        end
      end

      context 'when duplicated' do
        before { create(:user) }

        context 'with same case' do
          it { expect(user).to_not be_valid }
        end

        context 'with another case' do
          let(:attr) do
            {
              name: User.first.name.upcase,
              email: 'other_dummy_user@example.com',
            }
          end
          it { expect(user).to_not be_valid }
        end
      end

      context 'when too short' do
        let(:attr) { { name: 's' } }
        it { expect(user).to_not be_valid }
      end

      context 'when too long' do
        let(:attr) { { name: 's' * 241 } }
        it { expect(user).to_not be_valid }
      end

      context 'when reserved' do
        context 'with defualt reserved username' do
          let(:attr) { { name: 'index' } }
          it { expect(user).to_not be_valid }
        end
      end
    end
  end
end
