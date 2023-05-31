# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Admin::DictionaryItemsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  let(:current_user) { nil }
  let!(:dictionary) { create(:dictionary) }
  let!(:dictionary_item) { create(:dictionary_item) }
  let!(:data) { attributes_for(:dictionary_item).merge(dictionary_id: dictionary.id) }

  before do
    3.times { create(:dictionary_item) }
    login_user(current_user) if current_user
  end

  # no logged user
  context "when no user is logged in" do
    describe "when getting action index" do
      it "redirects to index" do
        get :index

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when getting action show" do
      it "redirects to login" do
        get :show, params: { id: dictionary_item.id }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when getting action new" do
      it "redirects to login" do
        get :new

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when trying to create" do
      it "redirects to login" do
        expect do
          post :create, params: { dictionary_item: data }
        end.not_to change { DictionaryItem.count }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when getting action edit" do
      it "redirects to login" do
        get :edit, params: { id: dictionary_item.id }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when trying to update" do
      it "redirects to login" do
        patch :update, params: { id: dictionary_item.id, dictionary_item: data }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe "when trying to destroy" do
      it "redirects to login" do
        expect do
          delete :destroy, params: { id: dictionary_item.id }
        end.not_to change { DictionaryItem.count }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end
  end

  # not an admin user
  context "when logged in user is not an admin" do
    let(:current_user) { user }
    describe "when getting action index" do
      it "redirects to index" do
        get :index

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe "when getting action show" do
      it "redirects to login" do
        get :show, params: { id: dictionary_item.id }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe "when getting action new" do
      it "redirects to root" do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe "when trying to create" do
      it "redirects to login" do
        expect do
          post :create, params: { dictionary_item: data }
        end.not_to change { DictionaryItem.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe "when getting action edit" do
      it "redirects to login" do
        get :edit, params: { id: dictionary_item.id }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe "when trying to update" do
      it "redirects to login" do
        patch :update, params: { id: dictionary_item.id, dictionary_item: data }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe "when trying to destroy" do
      it "redirects to login" do
        expect do
          delete :destroy, params: { id: dictionary_item.id }
        end.not_to change { DictionaryItem.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end
  end

  context "for logged in user" do
    let(:current_user) { admin }

    describe "when getting action index" do
      it "renders view" do
        get :index

        expect(response).to render_template(:index)
      end
    end

    describe "when getting action show" do
      it "renders show" do
        get :show, params: { id: dictionary_item.id }

        expect(response).to render_template(:show)
      end
    end

    describe "when getting action new" do
      it "renders view" do
        get :new

        expect(response).to render_template(:new)
      end
    end

    describe "when creating dictionary_item with valida data" do
      it "creates item" do
        expect do
          patch :create, params: { dictionary_item: data }
        end.to change { DictionaryItem.count }.by(1)

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:notice]).to eq(I18n.t('admin.dictionary_items.create.success'))
        dictionary_item = DictionaryItem.last
        expect(dictionary_item.name).to eq data[:name]
      end
    end

    describe "when creating dictionary_item with invalid data" do
      it "creates item" do
        expect do
          patch :create, params: { dictionary_item: {} }
        end.not_to change { DictionaryItem.count }

        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq(I18n.t('admin.dictionary_items.create.error'))
      end
    end

    describe "when getting action edit" do
      it "renders edit" do
        get :edit, params: { id: dictionary_item.id }

        expect(response).to render_template(:edit)
      end
    end

    describe "when getting action edit of non existent dictionary_item" do
      it "redirects to index" do
        nonexistent_index = 33
        expect(DictionaryItem.find_by(id: nonexistent_index)).to be nil
        get :edit, params: { id: nonexistent_index }

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:alert]).to eq(I18n.t('admin.dictionary_items.show.no_item'))
      end
    end

    describe "when updating user with valida data" do
      it "redirects to index" do
        old_name = dictionary_item.name
        patch :update, params: { id: dictionary_item.id, dictionary_item: data }

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:notice]).to eq(I18n.t('admin.dictionary_items.update.success'))
        dictionary_item.reload
        expect(dictionary_item.name).not_to eq old_name
        expect(dictionary_item.name).to eq data[:name]
      end
    end

    describe "when updating user with invalid data" do
      it "returns error message" do
        old_name = dictionary_item.name
        patch :update, params: { id: dictionary_item.id, dictionary_item: {} }

        expect(flash[:alert]).to eq(I18n.t("admin.dictionary_items.update.error"))
        expect(response.status).to eq(200)
        expect(subject).to render_template(:edit)
        dictionary_item.reload
        expect(dictionary_item.name).not_to eq data[:name]
        expect(dictionary_item.name).to eq old_name
      end
    end

    describe "when destroying dictionary_item" do
      it "it is destroyed" do
        expect do
          delete :destroy, params: { id: dictionary_item.id }
        end.to change { DictionaryItem.count }.by(-1)

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:notice]).to eq(I18n.t("admin.dictionary_items.destroy.success"))
      end
    end

    describe "when destroying dictionary_item with non existing index" do
      it "redirects to index" do
        nonexistent_index = 33
        expect(DictionaryItem.find_by(id: nonexistent_index)).to be nil
        expect do
          delete :destroy, params: { id: nonexistent_index }
        end.not_to change { DictionaryItem.count }

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:alert]).to eq(I18n.t("admin.dictionary_items.show.no_item"))
      end
    end
  end
end