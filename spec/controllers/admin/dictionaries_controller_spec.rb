# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DictionariesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  let(:current_user) { nil }
  let!(:dictionary) { create(:dictionary) }
  let!(:data) do
    { name: Faker::Lorem.word(exclude_words: dictionary.name ) }
  end

  before do
    3.times { create(:dictionary) }
    login_user(current_user) if current_user
  end

  # no logged user
  context 'when no user is logged in' do
    describe 'when getting action index' do
      it 'redirects to index' do
        get :index, params: { admin_scope: true }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe 'when getting action show' do
      it 'redirects to login' do
        get :show, params: { id: dictionary.id, admin_scope: true }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe 'when getting action new' do
      it 'redirects to login' do
        get :new, params: { admin_scope: true }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe 'when trying to create' do
      it 'redirects to login' do
        expect do
          post :create, params: { dictionary: data, admin_scope: true }
        end.not_to change { Dictionary.count }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe 'when getting action edit' do
      it 'redirects to login' do
        get :edit, params: { id: dictionary.id, admin_scope: true }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe 'when trying to update' do
      it 'redirects to login' do
        patch :update, params: { id: dictionary.id, dictionary: data, admin_scope: true }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end

    describe 'when trying to destroy' do
      it 'redirects to login' do
        expect do
          delete :destroy, params: { id: dictionary.id, admin_scope: true }
        end.not_to change { Dictionary.count }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.login_required'))
      end
    end
  end

  # not an admin user
  context 'when logged in user is not an admin' do
    let(:current_user) { user }
    describe 'when getting action index' do
      it 'redirects to index' do
        get :index, params: { admin_scope: true }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe 'when getting action show' do
      it 'redirects to login' do
        get :show, params: { id: dictionary.id, admin_scope: true }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe 'when getting action new' do
      it 'redirects to root' do
        get :new, params: { admin_scope: true }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe 'when trying to create' do
      it 'redirects to login' do
        expect do
          post :create, params: { dictionary: data, admin_scope: true }
        end.not_to change { Dictionary.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe 'when getting action edit' do
      it 'redirects to login' do
        get :edit, params: { id: dictionary.id, admin_scope: true }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe 'when trying to update' do
      it 'redirects to login' do
        patch :update, params: { id: dictionary.id, dictionary: data, admin_scope: true }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end

    describe 'when trying to destroy' do
      it 'redirects to login' do
        expect do
          delete :destroy, params: { id: dictionary.id, admin_scope: true }
        end.not_to change { Dictionary.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('flash_messages.admin_required'))
      end
    end
  end

  context 'for logged in user' do
    let(:current_user) { admin }

    describe 'when getting action index' do
      it 'renders view' do
        get :index, params: { admin_scope: true }

        expect(response).to render_template(:index)
      end
    end

    describe 'when getting action show' do
      it 'renders show' do
        get :show, params: { id: dictionary.id, admin_scope: true }

        expect(response).to render_template(:show)
      end
    end

    describe 'when getting action new' do
      it 'renders view' do
        get :new, params: { admin_scope: true }

        expect(response).to render_template(:new)
      end
    end

    describe 'when creating dictionary with valida data' do
      it 'creates item' do
        expect do
          post :create, params: { dictionary: data, admin_scope: true }
        end.to change { Dictionary.count }.by(1)

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:notice]).to eq(I18n.t('admin.dictionaries.create.success'))
        dictionary = Dictionary.last
        expect(dictionary.name).to eq data[:name]
      end
    end

    describe 'when creating dictionary with invalid data' do
      it 'creates item' do
        expect do
          post :create, params: { dictionary: {}, admin_scope: true }
        end.not_to change { Dictionary.count }

        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq(I18n.t('admin.dictionaries.create.error'))
      end
    end

    describe 'when getting action edit' do
      it 'renders edit' do
        get :edit, params: { id: dictionary.id, admin_scope: true }

        expect(response).to render_template(:edit)
      end
    end

    describe 'when getting action edit of non existent dictionary' do
      it 'redirects to index' do
        nonexistent_index = 33
        expect(Dictionary.find_by(id: nonexistent_index)).to be nil
        get :edit, params: { id: nonexistent_index, admin_scope: true }

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:alert]).to eq(I18n.t('admin.dictionaries.show.no_item'))
      end
    end

    describe 'when updating user with valida data' do
      it 'redirects to index' do
        old_name = dictionary.name
        patch :update, params: { id: dictionary.id, dictionary: data, admin_scope: true }

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:notice]).to eq(I18n.t('admin.dictionaries.update.success'))
        dictionary.reload
        expect(dictionary.name).not_to eq old_name
        expect(dictionary.name).to eq data[:name]
      end
    end

    describe 'when updating user with invalid data' do
      it 'returns error message' do
        old_name = dictionary.name
        patch :update, params: { id: dictionary.id, dictionary: {}, admin_scope: true }

        expect(flash[:alert]).to eq(I18n.t('admin.dictionaries.update.error'))
        expect(response.status).to eq(200)
        expect(subject).to render_template(:edit)
        dictionary.reload
        expect(dictionary.name).not_to eq data[:name]
        expect(dictionary.name).to eq old_name
      end
    end

    describe 'when destroying dictionary' do
      it 'it is destroyed' do
        expect do
          delete :destroy, params: { id: dictionary.id, admin_scope: true }
        end.to change { Dictionary.count }.by(-1)

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:notice]).to eq(I18n.t('admin.dictionaries.destroy.success'))
      end
    end

    describe 'when destroying dictionary with non existing index' do
      it 'redirects to index' do
        nonexistent_index = 33
        expect(Dictionary.find_by(id: nonexistent_index)).to be nil
        expect do
          delete :destroy, params: { id: nonexistent_index, admin_scope: true }
        end.not_to change { Dictionary.count }

        expect(response).to redirect_to(admin_dictionaries_path)
        expect(flash[:alert]).to eq(I18n.t('admin.dictionaries.show.no_item'))
      end
    end
  end
end