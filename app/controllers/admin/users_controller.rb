# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    def new
      @form = Admin::UserCreateForm.new
    end

    def show
      redirect_to(default_redirect_path, alert: I18n.t('no_item', scope: 'admin.users.show')) and return unless item
    end

    def create
      @form = Admin::UserCreateForm.from_params(params)

      Admin::CreateUser.call(@form, current_user) do
        on(:ok) { redirect_to(admin_users_path, notice: I18n.t('success', scope: 'admin.users.create')) }
        on(:invalid) do
          flash.now[:alert] = I18n.t('error', scope: 'admin.users.create')
          render :new
        end
      end
    end

    def edit
      redirect_to(default_redirect_path, alert: I18n.t('no_item', scope: 'admin.users.show')) and return unless item

      @form = Admin::UserUpdateForm.from_model(item)
    end

    def update
      redirect_to(default_redirect_path, alert: I18n.t('no_item', scope: 'admin.users.show')) and return unless item

      @form = Admin::UserUpdateForm.from_params(params)

      Admin::UpdateUser.call(@form, item, current_user) do
        on(:ok) { redirect_to(default_redirect_path, notice: I18n.t('success', scope: 'admin.users.update')) }
        on(:invalid) do
          flash.now[:alert] = I18n.t('error', scope: 'admin.users.update')
          render :edit
        end
      end
    end

    def destroy
      redirect_to(default_redirect_path, alert: I18n.t('no_item', scope: 'admin.users.show')) and return unless item

      Admin::DestroyUser.call(item, current_user) do
        on(:ok) { redirect_to(default_redirect_path, notice: I18n.t('success', scope: 'admin.users.destroy')) }
        on(:invalid) do
          redirect_to(default_redirect_path, alert: I18n.t('error', scope: 'admin.users.destroy'))
        end
      end
    end

    private

    def items
      User.all
    end

    def item
      items.find_by(id: params[:id])
    end

    def default_redirect_path
      admin_users_path
    end
  end
end
