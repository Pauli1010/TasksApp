# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CreateDictionaryItem do
  subject { described_class.new(form, user) }
  let(:form) { Admin::DictionaryItemForm.from_params({ name: name, dictionary_id: dictionary.id }) }
  let(:dictionary) { create(:dictionary) }
  let(:name) { Faker::Lorem.words(number: 3).join(' ').capitalize }
  let(:user) { create(:user, :admin) }

  describe 'with valid form' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'call creates dictionary item' do
      expect { subject.call }.to change { DictionaryItem.count }.by(1)
      dictionary_item = DictionaryItem.last
      expect(dictionary_item.name).to eql name
      expect(dictionary_item.dictionary).to eql dictionary
    end
  end

  describe 'form with invalid data' do
    let(:name) { '' }
    it 'call returns invalid' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call does not create user' do
      expect { subject.call }.not_to change { DictionaryItem.count }
    end
  end
end



