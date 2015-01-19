require 'rails_helper'

RSpec.describe UserResume, type: :model do
  let(:old_time) { 1.minute.ago.change(usec: 0) }
  let(:current_time) { Time.now.change(usec: 0) }

  describe 'after save' do
    shared_examples 'touchs user' do
      specify { expect { subject }.to change { User.first.updated_at }.from(old_time).to(current_time) }
    end

    context 'when create' do
      subject do
        Timecop.freeze(current_time) do
          UserResume.create(user_id: User.first.id, body: 'foobar')
        end
      end

      before do
        Timecop.freeze(old_time) { create(:user) }
      end

      include_examples 'touchs user'
    end

    context 'when update' do
      subject do
        Timecop.freeze(current_time) do
          User.first.resume.update_attributes(body: 'hogepiyo')
        end
      end

      before do
        Timecop.freeze(old_time) do
          user = create(:user)
          UserResume.create(user_id: user.id, body: 'dummy')
        end
      end

      include_examples 'touchs user'
    end
  end
end
