# frozen_string_literal: true

# AccountController provides logic for maintaining User's own data
class AccountController < ApplicationController
  def show; end

  def edit
    @form = AccountForm.from_model(current_user)
  end

  def update
    @form = AccountForm.from_params(params)

    UpdateAccount.call(@form, current_user) do
      on(:ok) { redirect_to(account_path, notice: t('success', scope: 'account.update')) }
      on(:invalid) do
        flash.now[:alert] = t('error', scope: 'account.update')
        render :edit
      end
    end
  end

  def edit_password
    @form = ChangePasswordForm.new
  end

  def update_password
    @form = ChangePasswordForm.from_params(params)
    ChangePassword.call(@form, current_user) do
      on(:ok) { redirect_to(account_path, notice: t('success', scope: 'account.update_password')) }
      on(:invalid) do
        flash.now[:alert] = t('error', scope: 'account.update_password')
        render :edit_password
      end
    end
  end
end
