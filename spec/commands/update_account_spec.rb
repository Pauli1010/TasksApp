# frozen_string_literal: true

RSpec.describe UpdateAccount do
  subject { described_class.new(form, user) }
  let!(:user) { create(:user) }
  let(:form) { AccountForm.from_params(data) }
  let(:data) do
    {
      user_name: user_name
    }
  end
  let(:user_name) { Faker::Name.name }
  let(:too_short_user_name) { 'a' }

  describe 'form with valid data' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'call updates user data' do
      subject.call
      user.reload
      expect(user.user_name).to eq user_name
    end
  end

  describe 'form with invalid data' do
    let(:user_name) { too_short_user_name }

    it 'call returns ok' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call updates user data' do
      subject.call
      user.reload
      expect(user.user_name).not_to eq user_name
    end
  end
end