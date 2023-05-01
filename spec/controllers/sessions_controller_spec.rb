# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user, data) }
  let(:current_user) { nil }
  let(:data) { attributes_for(:user) }

  before do
    login_user(current_user) if current_user
  end

  describe "when no user is logged in" do
    it "renders new" do
      get :new

      expect(subject).to render_template('layouts/login')
      expect(subject).to render_template(:new)
    end
  end

  context "for logged in user" do
    let(:current_user) { user }
    describe "when getting action new" do
      it "redirects to root" do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("registrations.new.already_logged_in"))
      end
    end

    describe "when trying to create" do
      it "redirects to root" do
        post :create, params: { email: data[:email], password: data[:password] }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("registrations.new.already_logged_in"))
      end
    end

    describe "when trying to destroy" do
      it "logs user out" do
        delete :destroy

        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq(I18n.t("sessions.destroy.success"))
        expect(assigns(:current_user)).to be nil
      end
    end
  end

  describe "when data is valid" do
    it 'logs in user' do
      post :create, params: { email: data[:email], password: data[:password] }

      expect(flash[:notice]).to eq(I18n.t("sessions.create.success"))
      expect(assigns(:current_user)).not_to be nil
      expect(assigns(:current_user)).to eq(user)
      expect(user.remember_me_token).to be nil
      expect(response).to redirect_to(account_path)
    end
  end

  describe "when data is valid and remember me token set" do
    it 'logs in user and created rememeber me token' do
      post :create, params: { email: data[:email], password: data[:password], remember_me: true }

      expect(flash[:notice]).to eq(I18n.t("sessions.create.success"))
      expect(assigns(:current_user)).not_to be nil
      expect(assigns(:current_user)).to eq(user)
      expect(assigns(:current_user).remember_me_token).not_to be nil
      expect(response).to redirect_to(account_path)
    end
  end


  describe "when data is invalid" do
    it 'does not log in user' do
      post :create, params: { email: data[:email], password: '' }

      expect(flash[:alert]).to eq(I18n.t("sessions.create.error"))
      expect(response.status).to eq(302)
      expect(subject).to redirect_to(login_path)
    end
  end

  describe 'when user is not logged in' do
    it 'destroy action redirects to login' do
      delete :destroy

      expect(response).to redirect_to(login_path)
    end
  end
end