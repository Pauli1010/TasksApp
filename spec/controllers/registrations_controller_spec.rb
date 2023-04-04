# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:user) { create(:user) }
  let!(:pending_user) { create(:user, :pending) }
  let(:current_user) { nil }

  let(:data) { attributes_for(:user) }

  before do
    login_user(current_user) if current_user
  end

  describe "when no user is logged in" do
    it "renders new" do
      get :new

      expect(subject).to render_template(:new)
      expect(assigns(:user).class.name).to eq('User')
      expect(assigns(:user).persisted?).to be false
    end
  end

  context "for logged in user" do
    let(:current_user) { user }
    describe "when getting action new" do
      it "redirects to root" do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("registration.new.already_logged_in"))
      end
    end

    describe "when trying to create" do
      it "redirects to root" do
        expect do
          expect do
            post :create, params: { user: data }
          end.not_to change(ActionMailer::Base.deliveries, :length)
        end.not_to change { User.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("registration.new.already_logged_in"))
      end
    end

    describe "when trying to activate" do
      it "redirects to root" do
        expect do
          get :activate, params: { id: pending_user.activation_token }
        end.not_to change { User.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("registration.new.already_logged_in"))
      end
    end
  end

  describe "when registration data is valid" do
    it 'creates the user' do
      expect do
        expect do
          post :create, params: { user: data }
        end.to change(ActionMailer::Base.deliveries, :length).by(1)
      end.to change { User.count }.by(1)

      expect(flash[:notice]).to eq(I18n.t("registration.create.success"))
      expect(response).to redirect_to(login_path)
    end
  end

  describe "when registration data is invalid" do
    it 'does not create user' do
      data[:email] = ''
      expect do
        post :create, params: { user: data }
      end.not_to change { User.count }

      expect(flash[:alert]).to eq(I18n.t("registration.create.error"))
      expect(response.status).to eq(200)
      expect(subject).to render_template(:new)
    end
  end

  describe "when trying to activate with wrong token" do
    it "redirects to root" do
      expect do
        get :activate, params: { id: pending_user.activation_token[3..-1] }
      end.not_to change { User.where(activation_state: 'pending').count }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq(I18n.t("registration.activate.error"))
      expect(pending_user.activation_state_pending?).to be true
    end
  end

  describe "when trying to activate with correct token" do
    it "activated user and redirects to login path" do
      expect do
        expect do
          get :activate, params: { id: pending_user.activation_token }
        end.not_to change(ActionMailer::Base.deliveries, :length)
      end.to change { User.where(activation_state: 'pending').count }.by(-1)

      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq(I18n.t("registration.activate.success"))
      pending_user.reload
      expect(pending_user.activation_state_pending?).to be false
      expect(pending_user.activation_token).to be nil
    end
  end
end