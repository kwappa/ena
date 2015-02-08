require 'rails_helper'

RSpec.describe TeamsHelper do
  describe '.team_summary' do
    let(:team) { build :team, description: description }
    subject(:summary) { helper.team_summary(team) }

    context 'when description does not match' do
      let(:description) { nil }
      specify { expect(summary).to be_empty }
    end

    context 'when description match' do
      let(:description) do
        <<-EOM
   this is an awesome team first ever. we develop fast, reliable and valiant products.

# mission of this team

* create great something
...
        EOM
      end
      specify { expect(summary).to be_start_with 'this is an awesome team' }
    end
  end
end
