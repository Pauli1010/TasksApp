# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:pending_user) { create(:pending_user) }
  let!(:resetting_user) do
    create(:user,
           reset_password_token: Faker::Internet.password(max_length: 20),
           reset_password_email_sent_at: Date.current - 2.hours)
  end
  let!(:locked_user) do
    create(:user,
           failed_logins_count: 11,
           unlock_token: Faker::Internet.password(max_length: 20),
           lock_expires_at: Date.current + 2.days)
  end

  let(:current_user) { nil }
  let(:pass) { Faker::Internet.password }

  before do
    login_user(current_user) if current_user
  end

  describe 'when no user is logged in' do
    it 'renders redirects' do
      get :new

      expect(subject).to render_template(:new)
      expect(assigns(:form).class.name).to eq('ResetPasswordForm')
    end
  end

  context 'for logged in user' do
    let(:current_user) { resetting_user }
    describe 'when getting action new' do
      it 'redirects to account' do
        get :new

        expect(response).to redirect_to(account_path)
        expect(flash[:notice]).to eq(I18n.t('password_resets.new.already_logged_in'))
      end
    end

    describe 'when trying to ask for reset' do
      it 'redirects to account' do
        expect do
          post :create, params: { email: user.email }
        end.not_to change { ActionMailer::Base.deliveries.length }

        expect(response).to redirect_to(account_path)
        expect(flash[:notice]).to eq(I18n.t('password_resets.new.already_logged_in'))
      end
    end

    describe 'when getting action edit' do
      it 'redirects to account' do
        get :edit, params: { id: resetting_user.reset_password_token }

        expect(response).to redirect_to(account_path)
        expect(flash[:notice]).to eq(I18n.t('password_resets.new.already_logged_in'))
      end
    end

    describe 'when trying to change password' do
      it 'redirects to account' do
        expect do
          patch :update, params: { id: resetting_user.reset_password_token }
        end.not_to change { User.where(reset_password_token: nil).count }

        expect(response).to redirect_to(account_path)
        expect(flash[:notice]).to eq(I18n.t('password_resets.new.already_logged_in'))
      end
    end
  end

  describe 'when provided email is saved in database' do
    it 'prepares user for password reset' do
      expect do
        expect do
          post :create, params: { email: user.email }
        end.to change { ActionMailer::Base.deliveries.length }.by(1)
      end.to change { User.where(reset_password_token: nil).count }.by(-1)

      expect(flash[:notice]).to eq(I18n.t('password_resets.create.success'))
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'when provided email is not saved in database' do
    it 'does returns proper response' do
      expect do
        expect do
          post :create, params: { email: Faker::Internet.email }
        end.not_to change { ActionMailer::Base.deliveries.length }
      end.not_to change { User.where(reset_password_token: nil).count }

      expect(flash[:alert]).to eq(I18n.t('password_resets.create.error'))
      expect(response.status).to eq(200)
      expect(subject).to render_template(:new)
    end
  end

  describe 'when trying to get edit with wrong token' do
    it 'redirects to root' do
      get :edit, params: { id: resetting_user.reset_password_token[3..] }

      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to eq(I18n.t('password_resets.edit.wrong_token'))
    end
  end

  describe 'when trying to change password with wrong token' do
    it 'redirects to root' do
      expect do
        patch :update,
              params: {
                id: resetting_user.reset_password_token[3..],
                user: {
                  password: pass,
                  password_confirmation: pass
                }
              }
      end.not_to change { User.where(reset_password_token: nil).count }

      expect(response).to redirect_to(edit_password_reset_path)
      expect(flash[:alert]).to eq(I18n.t('password_resets.edit.wrong_token'))
      resetting_user.reload
      expect(resetting_user.reset_password_token).not_to be nil
    end
  end

  describe 'when trying to change password with unmatchig passwords' do
    it 'redirects to root' do
      expect do
        patch :update,
              params: {
                id: resetting_user.reset_password_token,
                user: {
                  password: pass,
                  password_confirmation: "#{pass}123"
                }
              }
      end.not_to change { User.where(reset_password_token: nil).count }

      expect(response).to have_http_status(200)
      expect(flash[:alert]).to eq(I18n.t('password_resets.update.error'))
      resetting_user.reload
      expect(resetting_user.reset_password_token).not_to be nil
    end
  end

  describe 'when trying to change password with correct token' do
    it 'resets user password and redirects to login path' do
      expect do
        patch :update,
              params: {
                id: resetting_user.reset_password_token,
                user: {
                  password: pass,
                  password_confirmation: pass
                }
              }
      end.to change { User.where(reset_password_token: nil).count }.by(1)

      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq(I18n.t('password_resets.update.success'))
      resetting_user.reload
      expect(resetting_user.reset_password_token).to be nil
    end
  end

  describe 'when user is logged and is trying to unlock with good token' do
    let(:current_user) { user }
    it 'redirects to root' do
      expect do
        get :unlock, params: { id: locked_user.unlock_token }
      end.not_to change { User.where(unlock_token: nil).count }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq(I18n.t('password_resets.unlock.logged_in_user'))
      locked_user.reload
      expect(locked_user.failed_logins_count).to eq(11)
      expect(locked_user.unlock_token).not_to be nil
      expect(locked_user.lock_expires_at).not_to be nil
    end
  end

  describe 'when locked user is trying to unlock with wrong token' do
    it 'redirects to root' do
      expect do
        get :unlock, params: { id: locked_user.unlock_token[0..-4] }
      end.not_to change { User.where(unlock_token: nil).count }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq(I18n.t('password_resets.unlock.error'))
      locked_user.reload
      expect(locked_user.failed_logins_count).to eq(11)
      expect(locked_user.unlock_token).not_to be nil
      expect(locked_user.lock_expires_at).not_to be nil
    end
  end

  describe 'when locked user is trying to unlock with wrong token' do
    it 'redirects to root' do
      expect do
        get :unlock, params: { id: locked_user.unlock_token }
      end.to change { User.where(unlock_token: nil).count }.by(1)

      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq(I18n.t('password_resets.unlock.success'))
      locked_user.reload
      expect(locked_user.failed_logins_count).to eq(0)
      expect(locked_user.unlock_token).to be nil
      expect(locked_user.lock_expires_at).to be nil
    end
  end
end