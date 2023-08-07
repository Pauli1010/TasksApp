# frozen_string_literal: true

module Admin
  class DictionaryItemsController < AdminController
    def new
      @form = Admin::DictionaryItemForm.from_params(params)
    end

    def show
      redirect_to(default_redirect_path, alert: t('show.no_item', scope: tr_scope)) and return unless item
    end

    def create
      @form = Admin::DictionaryItemForm.from_params(params)

      Admin::CreateDictionaryItem.call(@form, current_user) do
        on(:ok) { redirect_to(admin_dictionaries_path, notice: t('create.success', scope: tr_scope)) }
        on(:invalid) do
          flash.now[:alert] = t('create.error', scope: tr_scope)
          render :new
        end
      end
    end

    def edit
      redirect_to(default_redirect_path, alert: t('show.no_item', scope: tr_scope)) and return unless item

      @form = Admin::DictionaryItemForm.from_model(item)
    end

    def update
      redirect_to(default_redirect_path, alert: t('show.no_item', scope: tr_scope)) and return unless item

      @form = Admin::DictionaryItemForm.from_params(params)

      Admin::UpdateDictionaryItem.call(@form, item, current_user) do
        on(:ok) { redirect_to(default_redirect_path, notice: t('update.success', scope: tr_scope)) }
        on(:invalid) do
          flash.now[:alert] = t('update.error', scope: tr_scope)
          render :edit
        end
      end
    end

    def destroy
      redirect_to(default_redirect_path, alert: t('show.no_item', scope: tr_scope)) and return unless item

      @form = Admin::DictionaryItemForm.from_params(params)

      Admin::DestroyDictionaryItem.call(@form, item, current_user) do
        on(:ok) { redirect_to(default_redirect_path, notice: t('destroy.success', scope: tr_scope)) }
        on(:invalid) do
          redirect_to(default_redirect_path, alert: t('destroy.error', scope: tr_scope))
        end
      end
    end

    private

    def items
      DictionaryItem.all
    end

    def item
      items.find_by(id: params[:id])
    end

    def default_redirect_path
      admin_dictionaries_path
    end

    def tr_scope
      'admin.dictionary_items'
    end
  end
end