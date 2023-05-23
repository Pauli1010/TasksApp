# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AccountController, type: :controller do
  let!(:user) { create(:user) }

  let(:current_user) { nil }
  let(:email) { Faker::Internet.email }
  let(:user_name) { Faker::Name.name }
  let(:too_long_user_name) { Faker::Alphanumeric.alpha(number: 90) }
  let(:pass) { Faker::Internet.password }

  before do
    login_user(current_user) if current_user
  end

  context "when no user is logged in" do
    describe "when getting action show" do
      it "redirects to login" do
        get :show

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when getting action edit" do
      it "redirects to login" do
        get :edit

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when trying to update" do
      it "redirects to login" do
        patch :update, params: { email: user.email }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end
  end

  context "for logged in user" do
    let(:current_user) { user }
    describe "when getting action show" do
      it "redirects to login" do
        get :show

        expect(response).to render_template(:show)
      end
    end

    describe "when getting action edit" do
      it "redirects to login" do
        get :edit

        expect(response).to render_template(:edit)
        expect(assigns(:form).class.name).to eq('AccountForm')
        expect(assigns(:form).persisted?).to be false
      end
    end

    describe "when updating user with valida data" do
      it "redirects to account" do
        patch :update, params: { user_name: user_name }

        expect(response).to redirect_to(account_path)
        expect(flash[:notice]).to eq(I18n.t('account.update.success'))
        user.reload
        expect(user.user_name).not_to equal user_name
        expect(user.user_name).to equal user.user_name
      end
    end

    describe "when updating user with invalid data" do
      it "returns error message" do
        patch :update, params: { user_name: too_long_user_name }

        expect(flash[:alert]).to eq(I18n.t("account.update.error"))
        expect(response.status).to eq(200)
        expect(subject).to render_template(:edit)
        user.reload
        expect(user.user_name).not_to equal too_long_user_name
        expect(user.user_name).to equal user.user_name
      end
    end

    describe "when trying to get edit_password" do
      it "renders" do
        get :edit_password

        expect(response).to render_template(:edit_password)
      end
    end

    describe "when updating password with valida data" do
      it 'updates the password' do
        old_password = user.crypted_password
        patch :update_password, params: {
                                 user: {
                                   password: pass,
                                   password_confirmation: pass
                                 }}

        expect(response).to redirect_to(account_path)
        expect(flash[:notice]).to eq(I18n.t("account.update_password.success"))
        user.reload
        expect(user.crypted_password).not_to eq old_password
      end
    end

    describe "when updating password with invalid data" do
      it 'updates the password' do
        old_password = user.crypted_password
        patch :update_password, params: {
          user: {
            password: pass,
            password_confirmation: pass[3..-1]
          }}

        expect(response).to render_template(:edit_password)
        expect(flash[:alert]).to eq(I18n.t("account.update_password.error"))
        user.reload
        expect(user.crypted_password).to eq old_password
      end
    end
  end
end