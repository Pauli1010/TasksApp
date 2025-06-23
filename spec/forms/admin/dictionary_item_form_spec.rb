# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DictionaryItemForm, type: :form do
  subject { described_class.from_params(name: name, dictionary_id: dictionary_id) }
  let(:dictionary) { create(:dictionary) }
  let(:dictionary_id) { dictionary.id }
  let(:name) { Faker::Lorem.word.downcase }

  describe 'with default data' do
    it { is_expected.to be_valid }
  end

  describe 'with blank dictionary id' do
    let(:dictionary_id) { '' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:dictionary_id].first).to eql I18n.t('errors.messages.blank', locale: :pl)
    end
  end

  describe 'with nil dictionary id' do
    let(:dictionary_id) { nil }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:dictionary_id].first).to eql I18n.t('errors.messages.blank', locale: :pl)
    end
  end

  describe 'with not existing dictionary' do
    let(:dictionary_id) { Dictionary.all.size + 100 }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:dictionary_id].first).to eql I18n.t('errors.messages.dictionary_not_found', locale: :pl)
    end
  end

  describe 'with empty name' do
    let(:name) { '' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:name].first).to eql I18n.t('errors.messages.blank', locale: :pl)
    end
  end

  describe 'with name similar to existing one' do
    let!(:dictionary_item) { create(:dictionary_item, name: "#{name}a", dictionary: dictionary) }

    it { is_expected.to be_valid }
  end

  describe 'with already existing name in different dictionary' do
    let!(:dictionary_item) { create(:dictionary_item, name: name, dictionary: create(:dictionary)) }

    it { is_expected.to be_valid }
  end

  describe 'with already existing name in the same dictionary' do
    let!(:dictionary_item) { create(:dictionary_item, name: name, dictionary: dictionary) }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:name].first).to eql I18n.t('errors.messages.taken_in_dictionary', locale: :pl)
    end
  end

  describe 'with already existing name with different case' do
    let!(:dictionary_item) { create(:dictionary_item, name: name.upcase, dictionary: dictionary) }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:name].first).to eql I18n.t('errors.messages.taken_in_dictionary', locale: :pl)
    end
  end
end