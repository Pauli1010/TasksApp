# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DictionaryForm, type: :form do
  subject { described_class.from_params(name: name) }
  let(:name) { Faker::Lorem.word.downcase }

  describe 'with default data' do
    it { is_expected.to be_valid }
  end

  describe 'with empty name' do
    let(:name) { '' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:name].first).to eql I18n.t('errors.messages.blank', locale: :pl)
    end
  end

  describe 'with already existing name' do
    let!(:dictionary) { create(:dictionary, name: name) }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:name].first).to eql I18n.t('errors.messages.taken', locale: :pl)
    end
  end

  describe 'with already existing name with different case' do
    let!(:dictionary) { create(:dictionary, name: name.upcase) }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:name].first).to eql I18n.t('errors.messages.taken', locale: :pl)
    end
  end
end