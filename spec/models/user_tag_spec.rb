require 'rails_helper'

RSpec.describe UserTag, type: :model do
  describe '.normalize_keyword' do
    let(:keyword) { 'keyword' }
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
end
