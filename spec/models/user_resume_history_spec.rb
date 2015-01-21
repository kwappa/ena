require 'rails_helper'

RSpec.describe UserResumeHistory, type: :model do
  let(:user) { create(:user) }

  describe '.record_diff' do
    subject(:record_diff) { described_class.record_diff(user.id, 'old_body', 'new_body') }
    specify { expect { record_diff }.to change { described_class.count }.from(0).to(1) }
  end

  describe '#quoted_diff' do
    let(:diff_body) { 'diff_body' }
    let(:quoted_diff_body) { "```diff\n#{diff_body}\n```\n" }
    let(:diff) { build(:user_resume_history, diff: diff_body) }
    specify { expect(diff.quoted_diff).to eq quoted_diff_body }
  end
end
