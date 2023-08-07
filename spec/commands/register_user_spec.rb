# frozen_string_literal: true

RSpec.describe RegisterUser do
  subject { described_class.new(form) }
  let(:form) { RegistrationForm.from_params(data) }
  let(:data) do
    {
      email: email,
      password: pass,
      password_confirmation: pass_conf
    }
  end
  let(:email) { Faker::Internet.email }
  let(:pass) { Faker::Internet.password }
  let(:pass_conf) { pass }

  describe 'form with valid data' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'call creates user' do
      expect { subject.call }.to change { User.count }.by(1)
    end
  end

  describe 'form with invalid data' do
    let(:pass_conf) { '' }
    it 'call returns invalid' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call does not create user' do
      expect { subject.call }.not_to change { User.count }
    end
  end
end