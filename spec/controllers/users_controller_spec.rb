require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  describe '#index' do
    let(:user) { create(:user) }
    subject(:index) { get :index }
    context 'when user does not login' do
      it { expect(index).to be_ok }
    end

    context 'when user login' do
      before { sign_in user }
      it { expect(index).to redirect_to home_path(user.nick) }
    end
  end

  describe '#list' do
    let(:params) { {} }
    let(:per_page) { UsersController::MEMBERS_PER_PAGE }
    let(:member_numbers) { (0..per_page).to_a.shuffle }
    let(:edit_orders)    { (0..per_page).to_a.shuffle }
    let!(:members)       { (0..per_page).map { |idx| create(:user, member_number: member_numbers[idx]) } }
    before { get :list, params }

    context 'default sort' do
      it 'sorted by alphabetically order' do

        expect(assigns[:members].pluck(:id)).to match User.order_by_nick.pluck(:id).first(per_page)
      end

      context 'with option "order=desc"' do
        let(:params) { { order: 'desc' } }
        it 'reverse sorted by alphabetically order' do
          expect(assigns[:members].pluck(:id)).to match User.order_by_nick.reverse_order.pluck(:id).first(per_page)
        end
      end
    end

    context 'sorted by member_number' do
      let(:params) { { sort: 'member_number' } }
      it 'sorted by member_number' do
        expect(assigns[:members].pluck(:id)).to match User.order_by_member_number.pluck(:id).first(per_page)
      end
    end

    context 'recent' do
      let(:params) { { sort: 'recent' } }
      before { edit_orders.map { |idx| members[idx].touch } }
      it 'sorted by updated_at desc' do
        expect(assigns[:members].pluck(:id)).to match User.recent.pluck(:id).first(per_page)
      end
    end
  end

  describe '#show' do
    let(:user) { create(:user) }
    subject(:show) { get :show, nick: user.nick }

    context 'when user is not logging in' do
      it { expect(show).to be_ok }
    end

    context 'when user is logging in as myself' do
      before { sign_in user }
      it { expect(show).to be_ok }
    end

    context 'when user does not found' do
      it { expect { get :show, nick: 'NOT_EXISTING_USER' }.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe '#resume_histories' do
    let(:user) { create(:user) }
    subject(:resume_histories) { get :resume_histories, nick: user.nick }

    context 'without resume' do
      it 'shows blank page' do
        expect(resume_histories).to be_ok
        expect(user.resume).to_not be_present
        expect(user.resume_histories).to_not be_present
      end
    end

    context 'with resume and histories' do
      let!(:resume) { create(:user_resume, user: user) }
      before { resume }
      it 'shows resume and histories' do
        expect(resume_histories).to be_ok
        expect(user.resume).to be_present
        expect(user.resume_histories).to be_present
      end
    end
  end
end
