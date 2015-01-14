require 'rails_helper'

RSpec.describe UserResumesController, type: :controller do
  let(:resume) { create(:user_resume) }

  describe '#new' do
    subject(:new_resume) { get :new }

    context 'when user does not login' do
      it { expect(new_resume).to redirect_to root_path }
    end

    context 'when login user without resume' do
      before { sign_in create(:user) }
      it { expect(new_resume).to be_ok }
    end

    context 'when login user with resume' do
      before { sign_in resume.user }
      it { expect(new_resume).to redirect_to edit_users_resume_path }
    end
  end

  describe '#edit' do
    subject(:new_resume) { get :edit }

    context 'when user does not login' do
      it { expect(new_resume).to redirect_to root_path }
    end

    context 'when login user without resume' do
      before { sign_in create(:user) }
      it { expect(new_resume).to redirect_to new_users_resume_path }
    end

    context 'when login user with resume' do
      before { sign_in resume.user }
      it { expect(new_resume).to be_ok }
    end
  end
end
