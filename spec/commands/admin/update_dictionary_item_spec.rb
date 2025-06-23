# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UpdateDictionaryItem do
  subject { described_class.new(form, dictionary_item, user) }
  let!(:dictionary) { create(:dictionary) }
  let!(:dictionary_item) { create(:dictionary_item, name: name, dictionary: dictionary) }
  let(:user) { create(:user, :admin) }
  let(:form) { Admin::DictionaryItemForm.from_params({ name: new_name, dictionary_id: new_dictionary.id }) }
  let(:name) { Faker::Lorem.words(number: 3).join(' ').capitalize }
  # update data
  let!(:new_dictionary) { create(:dictionary) }
  let(:new_name) { Faker::Lorem.words(number: 3).join(' ').capitalize }

  describe 'with valid form' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'call creates dictionary' do
      expect { subject.call }.not_to change { DictionaryItem.count }
      dictionary_item.reload
      # proper data has changed
      expect(dictionary_item.name).to eql new_name
      expect(dictionary_item.dictionary).to eql new_dictionary
    end
  end

  describe 'form with invalid data' do
    let(:new_name) { '' }
    it 'call returns invalid' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call does not create user' do
      expect { subject.call }.not_to change { DictionaryItem.count }
      dictionary.reload
      # no data has changed
      expect(dictionary_item.name).to eql name
      expect(dictionary_item.dictionary).to eql dictionary
    end
  end
end



