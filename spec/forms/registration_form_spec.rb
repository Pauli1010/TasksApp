# frozen_string_literal: true

RSpec.describe RegistrationForm, type: :form do
  subject { described_class.from_params(email: email, password: pass, password_confirmation: pass_conf) }
  let(:email) { Faker::Internet.email }
  let(:pass) { Faker::Internet.password }
  let(:pass_conf) { pass }

  let(:user) { create(:user) }

  describe 'with default data' do
    it { is_expected.to be_valid }
  end

  describe 'without email' do
    let(:email) { '' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:email].first).to eql I18n.t('errors.email.required', locale: :pl)
    end
  end

  context 'with invalid email' do
    describe 'that has no @' do
      invalid_email = 'user_@example.'
      let(:email) { invalid_email }

      it { is_expected.not_to be_valid }
      it 'has proper error message' do
        subject.validate
        expect(subject.email).to eql invalid_email
        expect(subject.errors[:email].first).to eql I18n.t('errors.email.invalid', locale: :pl)
      end
    end

    describe 'that has no characters in the end' do
      invalid_email = 'user_example.com'
      let(:email) { invalid_email }
      it 'has proper error message' do
        subject.validate
        expect(subject.email).to eql invalid_email
        expect(subject.errors[:email].first).to eql I18n.t('errors.email.invalid', locale: :pl)
      end
    end
  end

  describe 'without password' do
    let(:pass) { '' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:password].first).to eql I18n.t('errors.password.required', locale: :pl)
    end
  end

  describe 'with too short password' do
    let(:pass) { 'pa' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:password].first).to eql I18n.t('errors.password.too_short', locale: :pl)
    end
  end

  describe 'with unmatching passwords' do
    let(:pass_conf) { Faker::Internet.password }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:password_confirmation].first).to eql I18n.t('errors.password_confirmation.different', locale: :pl)
    end
  end

  describe 'with empty password confirmation' do
    let(:pass_conf) { '' }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:password_confirmation].first).to eql I18n.t('errors.password_confirmation.different', locale: :pl)
    end
  end

  describe 'with already used email' do
    let(:email) { user.email }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:email].first).to eql I18n.t('errors.email.taken', locale: :pl)
    end
  end

  describe 'with already used email with uppercase' do
    let(:email) { user.email.upcase }

    it { is_expected.not_to be_valid }
    it 'has proper error message' do
      subject.validate
      expect(subject.errors[:email].first).to eql I18n.t('errors.email.taken', locale: :pl)
    end
  end
end