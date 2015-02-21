require 'rails_helper'

RSpec.describe Occupation do
  describe '.id' do
    subject(:occupation_id) { described_class.id(occupation_name) }

    context 'with valid occupation name' do
      let(:occupation_name) { :director }
      specify { expect(occupation_id).to eq 3 }
    end

    context 'with invalid occupation name' do
      let(:occupation_name) { :invalid_occupation_name }
      specify { expect { occupation_id }.to raise_error ArgumentError }
    end
  end

  describe '.name' do
    subject(:occupation_name) { described_class.name(occupation_id) }

    context 'with valid occupation id' do
      let(:occupation_id) { 2 }
      specify { expect(occupation_name).to eq :designer }
    end

    context 'with invalid occupation id' do
      let(:occupation_id) { 999999999 }
      specify { expect { occupation_name }.to raise_error ArgumentError }
    end
  end
end
