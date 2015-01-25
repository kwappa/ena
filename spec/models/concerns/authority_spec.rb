require 'rails_helper'

RSpec.describe Authority do
  describe '.id' do
    let(:authority_name) { '' }
    subject(:authority_id) { described_class.id(authority_name) }

    context 'with valid authority name' do
      context ':working' do
        let(:authority_name) { :working }
        it 'returns authority id by name' do
          expect(authority_id).to eq 0
        end
      end

      context ':administration' do
        let(:authority_name) { :administration }
        it 'returns authority id by name' do
          expect(authority_id).to eq 4
        end
      end
    end

    context 'with invalid authority name' do
      let(:authority_name) { 'INVALID_AUTHORITY_NAME' }
      specify { expect { authority_id }.to raise_error ArgumentError }
    end
  end

  describe '.name' do
    subject(:authority_name) { described_class.name(authority_id) }
    context 'when direction' do
      let(:authority_id) { 3 }
      specify { expect(authority_name).to eq :direction }
    end

    context 'when invalid id' do
      let(:authority_id) { 999999 }
      specify { expect { authority_name }.to raise_error ArgumentError }
    end
  end
end

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#authorize' do
    subject(:authorize) { user.authorize(authority_name) }

    context 'with valid authority name' do
      let(:authority_name) { :administration }
      let(:authority_id)   { 4 }
      specify { expect { authorize }.to change { user.authority_id }.from(0).to(authority_id) }
    end

    context 'with invalid authority name' do
      let(:authority_name) { 'INVALID_AUTHORITY_NAME' }
      let(:authority_id)   { 4 }
      specify { expect { authorize }.to raise_error ArgumentError }
    end
  end

  describe '#authority' do
    subject(:authority) { user.authority }
    context 'when working' do
      specify { expect(authority).to eq :working }
    end

    context 'whern administration' do
      before { user.authorize(:administration) }
      specify { expect(authority).to eq :administration }
    end
  end
end
