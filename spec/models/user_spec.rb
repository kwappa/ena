require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    let(:user) { build(:user) }
    subject(:user) { build(:user, attr) }
    let(:attr) { { } }

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
        let!(:existing_user) { create(:user) }

        context 'with same case' do
          let(:attr) { { name: existing_user.name } }
          it { expect(user).to_not be_valid }
        end

        context 'with another case' do
          let(:attr) { { name: existing_user.name.upcase } }
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
        let(:duplicated_email) { 'duplicated_email@example.com' }
        before { create(:user, email: duplicated_email) }

        context 'with same case' do
          let(:attr) { { email: duplicated_email } }
          it { expect(user).to_not be_valid }
        end

        context 'with another case' do
          let(:attr) { { email: duplicated_email.upcase } }
          it { expect(user).to_not be_valid }
        end
      end
    end

    describe 'nick' do
      let(:duplicated_nick) { 'duplicated_nick' }

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
        before { create(:user, nick: duplicated_nick) }
        let(:attr) { { nick: duplicated_nick } }
        it { expect(user).to_not be_valid }
      end
    end

    describe 'member_number' do
      context 'when duplicated' do
        let(:member_number) { nil }
        before do
          create(:user,
                 name: 'duplicated_member_number_name',
                 nick: 'duplicated_member_number_nick',
                 email: 'duplicated_member_number@example.com',
                 member_number: member_number
                )
        end

        context 'with nil' do
          let(:member_number) { nil }
          let(:attr) { { member_number: member_number } }
          it { expect(user).to be_valid }
        end

        context 'with blank' do
          let(:member_number) { '' }
          let(:attr) { { member_number: member_number } }
          it { expect(user).to be_valid }
        end

        context 'with duplicated value' do
          let(:member_number) { 'duplicated_member_number' }
          let(:attr) { { member_number: member_number } }
          it { expect(user).to_not be_valid }
        end
      end
    end
  end

  describe 'scope to specify order' do
    let!(:alice)   { create(:user, name: 'alice',   nick: 'alice',   email: 'alice@example.com',   member_number: '2') }
    let!(:bob)     { create(:user, name: 'bob',     nick: 'bob',     email: 'bob@example.com',     member_number: '1') }
    let!(:charlie) { create(:user, name: 'charlie', nick: 'charlie', email: 'charlie@example.com', member_number: '3') }

    describe ':order_by_nick' do
      it { expect(User.order_by_nick.all).to match([alice, bob, charlie]) }
    end

    describe ':recent' do
      it { expect(User.recent.all).to match([charlie, bob, alice]) }
    end

    describe ':order_by_member_number' do
      it { expect(User.order_by_member_number.all).to match([bob, alice, charlie]) }
    end
  end

  describe 'tag operation' do
    let(:user) { create(:user) }
    let(:keyword) { 'a keyword' }
    let(:another_keyword) { 'another keyword' }

    describe '#tag_keyword' do
      subject(:tagging) { user.tag_keyword(keyword) }

      context 'with a keyword' do
        it { expect { tagging }.to change { user.tags.count }.from(0).to(1) }
      end

      context 'repeat with same keyword' do
        before { user.tag_keyword(keyword) }
        it { expect { tagging }.to_not change { user.tags.count }.from(1) }
      end

      context 'repeat with another keyword' do
        before { user.tag_keyword(another_keyword) }
        it { expect { tagging }.to change { user.tags.count }.from(1).to(2) }
      end
    end

    describe '#detach_tag' do
      let(:tag) { UserTag.retrieve(keyword) }
      subject(:detach) { user.detach(tag) }
      before { user.tag_keyword(another_keyword) }

      context 'with not attached tag' do
        it { expect { detach }.to_not change { user.tags.count }.from(1) }
      end

      context 'with attached tag' do
        before { user.tag_keyword(keyword) }
        it { expect { detach }.to change { user.tags.count }.from(2).to(1) }
      end
    end
  end
end
