# frozen_string_literal: true

RSpec.describe ChangePassword do
  subject { described_class.new(form, user) }
  let!(:user) { create(:user) }
  let(:form) { ChangePasswordForm.from_params(data) }
  let(:data) do
    {
      password: pass,
      password_confirmation: pass_conf
    }
  end
  let!(:old_pass) { user.crypted_password }
  let(:pass) { Faker::Internet.password }
  let(:pass_conf) { pass }

  describe 'form with valid data' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'updates password' do
      subject.call
      user.reload
      expect(user.crypted_password).not_to eql(old_pass)
    end
  end

  describe 'form with invalid data' do
    let(:pass_conf) { '' }
    it 'call returns invalid' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call does not update password' do
      subject.call
      user.reload
      expect(user.crypted_password).to eql(old_pass)
    end
  end
end