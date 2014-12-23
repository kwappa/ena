require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    subject(:user) { build(:user, attr) }
    let(:attr) { {} }

    describe 'name' do
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

    describe 'email' do
      context 'when blank' do
        let(:attr) { { email: '' } }
        it { expect(user).to_not be_valid }
      end

      context 'when invalid format' do
        let(:attr) { { email: 'INVALID_EMAIL_FORMAT' } }
        it { expect(user).to_not be_valid }
      end

      context 'when duplicated' do
        before { create(:user, name: 'other_dummy_user') }

        context 'with same case' do
          it { expect(user).to_not be_valid }
        end

        context 'with another case' do
          let(:attr) do
            {
              name: 'yet_another_dummy_user',
              email: 'default_user@example.com'.upcase
            }
          end
          it { expect(user).to_not be_valid }
        end
      end
    end

    describe 'nick' do
      context 'when blank' do
        let(:attr) { { nick: '' } }
        it { expect(user).to_not be_valid }
      end

      context 'when includes invalid character' do
        let(:attr) { { nick: 'my@nickname' } }
        it { expect(user).to_not be_valid }
      end

      context 'when includes non-ASCII' do
        let(:attr) { { nick: 'user_ニック_name' } }
        it { expect(user).to_not be_valid }
      end

      context 'when duplicated' do
        before { create(:user, name: 'nick_duplicated_user', email: 'nick_dup@example.com') }
        it { expect(user).to_not be_valid }
      end
    end
  end
end
