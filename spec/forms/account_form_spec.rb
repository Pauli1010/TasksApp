# frozen_string_literal: true

RSpec.describe AccountForm, type: :form do
  subject { described_class.from_params(user_name: user_name) }
  let(:user_name) { Faker::Name.name }

  let(:user) { create(:user) }

  describe 'with default data' do
    it { is_expected.to be_valid }
  end

  describe 'with empty user_name' do
    let(:user_name) { '' }

    it { is_expected.to be_valid }
  end


  describe 'with too short user_name' do
    let(:user_name) { 'a' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:user_name].first).to eql I18n.t('errors.messages.too_short.few', count: 3, locale: :pl)
    end
  end

  describe 'with too short user_name' do
    let(:user_name) { Faker::Alphanumeric.alpha(number: 31) }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:user_name].first).to eql I18n.t('errors.messages.too_long.other', count: 30, locale: :pl)
    end
  end
end