require 'rails_helper'

RSpec.describe UserTagsController, type: :controller do
  let!(:alice) { create(:user, nick: 'alice') }
  let!(:bob)   { create(:user, nick: 'bob') }
  let(:tag_name) { 'tag_name' }

  describe '#index' do
    before do
      5.times { create(:user_tag) }
      get(:index)
    end

    it 'assigns list of tags' do
      expect(assigns[:tags]).to match_array UserTag.page(1)
    end
  end

  describe '#show' do
    let(:tag_id) { 0 }
    subject(:show) { get :show, id: tag_id }

    context 'when tag does not exist' do
      specify { expect { show }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'when tag exists' do
      let!(:tag) { create(:user_tag) }
      let(:tag_id) { tag.id }

      before do
        tag.attach(alice)
        tag.attach(bob)
        show
      end

      it 'assigns tag and members' do
        expect(assigns[:members]).to match_array User.page(1)
        expect(assigns[:tag]).to eq UserTag.first
      end
    end
  end

  describe '#attach' do
    let(:target_nick) { alice.nick }
    subject(:attach) { post :attach, nick: target_nick, name: tag_name }

    context 'when attach to myself' do
      before { sign_in alice }

      context 'when new keyword is given' do
        it 'create and attach new tag to alice' do
          expect(alice.tags.count).to eq 0
          expect(UserTag.count).to eq 0
          attach
          expect(alice.tags.count).to eq 1
          expect(UserTag.count).to eq 1
        end
      end

      context 'when keyword that already exist is given' do
        before { UserTag.retrieve(tag_name) }
        it 'attach tag to alice' do
          expect(alice.tags.count).to eq 0
          expect(UserTag.count).to eq 1
          attach
          expect(alice.tags.count).to eq 1
          expect(UserTag.count).to eq 1
        end
      end
    end

    context 'when attach to other user' do
      before { sign_in bob }

      it 'create and attach new tag to alice' do
        expect { attach }.to change { alice.tags.count }.from(0).to(1)
      end
    end

    context 'when user does not exist' do
      let(:target_nick) { 'NOT_EXISTING_USER' }
      before { sign_in alice }
      it { expect { attach }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'when guest user' do
      before { attach }
      specify { expect(response).to redirect_to new_user_session_path }
    end
  end

  describe '#detach' do
    let(:tag) { UserTag.retrieve(tag_name) }
    let(:tag_id) { tag.id }
    let(:target_nick) { alice.nick }
    subject(:detach) { delete :detach, nick: target_nick, tag_id: tag_id }
    before { tag.attach(alice) }

    context 'when guest user' do
      before { detach }
      specify { expect(response).to redirect_to new_user_session_path }
    end

    context 'when alice' do
      before { sign_in alice }

      context 'with existing tag' do
        it 'removes tag from user' do
          expect { detach }.to change { alice.tags.count }.from(1).to(0)
        end
      end

      context 'with invalid tag_id' do
        let(:tag_id) { UserTag.maximum(:id) + 1 }
        it { expect { detach }.to raise_error ActiveRecord::RecordNotFound }
      end
    end

    context 'when bob' do
      before { sign_in bob }
        it { expect { detach }.to_not change { alice.tags.count }.from(1) }
    end
  end
end
