# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CreateDictionary do
  subject { described_class.new(form, user) }
  let(:form) { Admin::DictionaryForm.from_params({ name: name }) }
  let(:name) { Faker::Lorem.words(number: 3).join(' ').capitalize }
  let(:user) { create(:user, :admin) }

  describe 'with valid form' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'call creates dictionary' do
      expect { subject.call }.to change { Dictionary.count }.by(1)
      dictionary = Dictionary.last
      expect(dictionary.name).to eql name
      expect(dictionary.sys_name).to eql name.downcase.split(' ').join('-')
    end
  end

  describe 'form with invalid data' do
    let(:name) { '' }
    it 'call returns invalid' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call does not create user' do
      expect { subject.call }.not_to change { Dictionary.count }
    end
  end
end



