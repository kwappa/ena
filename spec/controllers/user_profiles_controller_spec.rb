require 'rails_helper'

RSpec.describe UserProfilesController, type: :controller do
  let(:profile) { create(:user_profile) }

  describe '#new' do
    subject(:new_profile) { get :new }

    context 'when user does not login' do
      it { expect(new_profile).to redirect_to root_path }
    end

    context 'when login user without profile' do
      before { sign_in create(:user) }
      it { expect(new_profile).to be_ok }
    end

    context 'when login user with profile' do
      before { sign_in profile.user }
      it { expect(new_profile).to redirect_to edit_users_profile_path }
    end
  end

  describe '#edit' do
    subject(:new_profile) { get :edit }

    context 'when user does not login' do
      it { expect(new_profile).to redirect_to root_path }
    end

    context 'when login user without profile' do
      before { sign_in create(:user) }
      it { expect(new_profile).to redirect_to new_users_profile_path }
    end

    context 'when login user with profile' do
      before { sign_in profile.user }
      it { expect(new_profile).to be_ok }
    end
  end
end
