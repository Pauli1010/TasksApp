# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:user) { create(:user) }
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
          post :create, params: { user: data }
        end.not_to change { User.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("registration.new.already_logged_in"))
      end
    end
  end

  describe "when data is valid" do
    it 'creates the user' do
      expect do
        post :create, params: { user: data }
      end.to change { User.count }.by(1)

      expect(flash[:notice]).to eq(I18n.t("registration.create.success"))
      expect(response).to redirect_to(login_path)
    end
  end

  describe "when data is invalid" do
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
end