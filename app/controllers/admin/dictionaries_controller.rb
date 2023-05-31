# frozen_string_literal: true

class Admin::DictionariesController < AdminController

  def new
    @form = Admin::DictionaryForm.new()
  end

  def show
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionaries.show')) and return unless item
  end

  def create
    @form = Admin::DictionaryForm.from_params(params)

    Admin::CreateDictionary.call(@form, current_user) do
      on(:ok) {
        redirect_to(admin_dictionaries_path, notice: t('success', scope: 'admin.dictionaries.create'))
      }
      on(:invalid) {
        flash.now[:alert] = t('error', scope: 'admin.dictionaries.create')
        render :new
      }
    end
  end

  def edit
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionaries.show')) and return unless item

    @form = Admin::DictionaryForm.from_model(item)
  end

  def update
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionaries.show')) and return unless item

    @form = Admin::DictionaryForm.from_params(params)

    Admin::UpdateDictionary.call(@form, item, current_user) do
      on(:ok) {
        redirect_to(default_redirect_path, notice: t('success', scope: 'admin.dictionaries.update'))
      }
      on(:invalid) {
        flash.now[:alert] = t('error', scope: 'admin.dictionaries.update')
        render :edit
      }
    end
  end
  def destroy
    redirect_to(default_redirect_path, alert: t('no_item', scope: 'admin.dictionaries.show')) and return unless item

    @form = Admin::DictionaryForm.from_params(params)

    Admin::DestroyDictionary.call(@form, item, current_user) do
      on(:ok) {
        redirect_to(default_redirect_path, notice: t('success', scope: 'admin.dictionaries.destroy'))
      }
      on(:invalid) {
        redirect_to(default_redirect_path, alert: t('error', scope: 'admin.dictionaries.destroy'))
      }
    end
  end

  private

  def items
    Dictionary.all
  end

  def item
    items.find_by(id: params[:id])
  end

  def default_redirect_path
    admin_dictionaries_path
  end
end
