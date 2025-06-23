# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UpdateDictionary do
  subject { described_class.new(form, dictionary, user) }
  let!(:dictionary) { create(:dictionary, name: name, sys_name: sys_name)}
  let(:form) { Admin::DictionaryForm.from_params({ name: new_name }) }
  let(:name) { Faker::Lorem.words(number: 3).join(' ').capitalize }
  let(:sys_name) { Faker::Lorem.words(number: 3).join('-') }
  let(:new_name) { Faker::Lorem.words(number: 3).join(' ').capitalize }
  let(:user) { create(:user, :admin) }

  describe 'with valid form' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'call creates dictionary' do
      expect { subject.call }.not_to change { Dictionary.count }
      dictionary.reload
      # proper data has changed
      expect(dictionary.name).to eql new_name
      expect(dictionary.sys_name).to eql sys_name
    end
  end

  describe 'form with invalid data' do
    let(:new_name) { '' }
    it 'call returns invalid' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call does not create user' do
      expect { subject.call }.not_to change { Dictionary.count }
      dictionary.reload
      # no data has changed
      expect(dictionary.name).to eql name
      expect(dictionary.sys_name).to eql sys_name
    end
  end
end



