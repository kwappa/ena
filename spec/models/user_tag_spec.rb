require 'rails_helper'

RSpec.describe UserTag, type: :model do
  let(:keyword) { 'ｎｏｒｍａｌｉｚｅｄ　K e y w o r d' }

  describe '.retrieve' do
    subject(:tag) { described_class.retrieve(keyword) }

    context 'when blank keywrod given' do
      let(:keyword) { '' }
      it { expect(tag).to be_nil }
    end

    context 'when new keyword given' do
      it { expect { tag }.to change { described_class.count }.from(0).to(1) }
      it 'creates with normalized keyword' do
        expect(tag.name).to eq 'normalizedKeyword'
      end
    end

    context 'when keyword already exist' do
      before { described_class.retrieve(keyword) }
      it { expect { tag }.to_not change { described_class.count }.from(1) }
    end

    context 'when same keyword already exist but with another case' do
      before { described_class.retrieve(keyword.upcase) }
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

  describe '#attach' do
    let(:first_tag)  { described_class.retrieve('first tag') }
    let(:second_tag) { described_class.retrieve('second tag') }
    let(:alice)      { create(:user) }

    context 'with tag that is not attached' do
      subject(:attach) { first_tag.attach(alice) }
      it { expect { attach }.to change { alice.tags.count }.from(0).to(1) }
    end

    context 'with tag that is already attached' do
      before { first_tag.attach(alice) }
      subject(:attach) { first_tag.attach(alice) }
      it { expect { attach }.to_not change { alice.tags.count }.from(1) }
      it { expect { second_tag.attach(alice) }.to change { alice.tags.count }.from(1).to(2) }
    end
  end
end
