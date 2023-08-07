# frozen_string_literal: true

RSpec.describe ResetPassword do
  subject { described_class.new(form) }
  let(:user) { create(:user) }
  let(:form) { ResetPasswordForm.from_params(email: email) }
  let!(:email) { user.email }
  let(:unused_email) { Faker::Internet.email }

  describe 'form with valid data' do
    it 'call returns ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    it 'updates password' do
      subject.call
      user.reload
      expect(user.reset_password_token).not_to be nil
    end

    it 'sends email' do
      expect { subject.call }.to change { ActionMailer::Base.deliveries.length }.by(1)
    end
  end

  describe 'form with invalid data' do
    let(:email) { unused_email }
    it 'call returns invalid' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'call does not update password' do
      subject.call
      user.reload
      expect(user.reset_password_token).to be nil
    end

    it 'does not send email' do
      expect { subject.call }.not_to change { ActionMailer::Base.deliveries.length }
    end
  end
end