# frozen_string_literal: true

class Admin::DictionaryItemsController < AdminController

  def new
    @form = Admin::DictionaryItemForm.from_params(params)
  end

  def show
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionary_items.show')) and return unless item
  end

  def create
    @form = Admin::DictionaryItemForm.from_params(params)

    Admin::CreateDictionaryItem.call(@form, current_user) do
      on(:ok) {
        redirect_to(admin_dictionaries_path, notice: t('success', scope: 'admin.dictionary_items.create'))
      }
      on(:invalid) {
        flash.now[:alert] = t('error', scope: 'admin.dictionary_items.create')
        render :new
      }
    end
  end

  def edit
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionary_items.show')) and return unless item

    @form = Admin::DictionaryItemForm.from_model(item)
  end

  def update
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionary_items.show')) and return unless item

    @form = Admin::DictionaryItemForm.from_params(params)

    Admin::UpdateDictionaryItem.call(@form, item, current_user) do
      on(:ok) {
        redirect_to(default_redirect_path, notice: t('success', scope: 'admin.dictionary_items.update'))
      }
      on(:invalid) {
        flash.now[:alert] = t('error', scope: 'admin.dictionary_items.update')
        render :edit
      }
    end
  end
  def destroy
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionary_items.show')) and return unless item

    @form = Admin::DictionaryItemForm.from_params(params)

    Admin::DestroyDictionaryItem.call(@form, item, current_user) do
      on(:ok) {
        redirect_to(default_redirect_path, notice: t('success', scope: 'admin.dictionary_items.destroy'))
      }
      on(:invalid) {
        redirect_to(default_redirect_path, alert: t('error', scope: 'admin.dictionary_items.destroy'))
      }
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
end
