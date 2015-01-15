require 'rails_helper'

RSpec.describe UserTag, type: :model do
  let(:keyword) { 'keyword' }

  describe '.retrieve' do
    subject(:tag) { described_class.retrieve(keyword) }

    context 'when new keyword given' do
      it { expect { tag }.to change { described_class.count }.from(0).to(1) }
    end

    context 'when keyword already exist' do
      before { described_class.retrieve(keyword) }
      it { expect { tag }.to_not change { described_class.count }.from(1) }
    end
  end

  describe '.normalize_keyword' do
    subject(:result) { described_class.normalize_keyword(keyword) }

    context 'includes blank' do
      let(:keyword) { "A B　C\rD\nE\tF\fG\vH" }
      it 'removes blank characters and full-width blank' do
        expect(result).to eq 'ABCDEFGH'
      end
    end

    context 'includes HIRAGANA / KATAKANA' do
      let(:keyword) { '漢字ｶﾀｶﾅひらがなカタカナ' }
      it 'converts hankaku-kana to zenkaku-kana' do
        expect(result).to eq '漢字カタカナひらがなカタカナ'
      end
    end

    context 'includes ZENKAKU alphabet and mark' do
      let(:keyword) { 'ｊａｖａｓｃｒｉｐｔ　ｆｕｎｃｔｉｏｎ（）' }
      it 'converts to ascii' do
        expect(result).to eq 'javascriptfunction()'
      end
    end
  end

  describe '.hash_keyword' do
    let(:keyword) { 'A B　Cｶﾀｶﾅひらがなｆｕｎｃｔｉｏｎ（）' }
    let(:normalized_and_downcased_keyword) { 'abcカタカナひらがなfunction()' }
    subject(:result) { described_class.hash_keyword(keyword) }

    it 'creates digest by keyword that normalized and downcased' do
      expect(result).to eq described_class.hash_keyword(normalized_and_downcased_keyword)
    end
  end
end
