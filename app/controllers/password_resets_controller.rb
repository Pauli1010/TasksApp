# frozen_string_literal: true

# PasswordResetsController provides logic for resetting password
class PasswordResetsController < ApplicationController
  layout 'login'
  skip_before_action :require_login

  def new
    redirect_to(account_path, notice: t('already_logged_in', scope: 'password_resets.new')) and return if current_user

    @form = ResetPasswordForm.new
  end

  def create
    redirect_to(account_path, notice: t('already_logged_in', scope: 'password_resets.new')) and return if current_user

    @form = ResetPasswordForm.from_params(params)
    ResetPassword.call(@form) do
      on(:ok) { redirect_to(login_path, notice: t('success', scope: 'password_resets.create')) }
      on(:invalid) do
        flash.now[:alert] = t('error', scope: 'password_resets.create')
        render :new
      end
    end
  end

  def edit
    redirect_to(account_path, notice: t('already_logged_in', scope: 'password_resets.new')) and return if current_user

    @token = params[:id]
    @user = User.find_by_reset_password_token(@token)

    redirect_to(login_path, alert: t('wrong_token', scope: 'password_resets.edit')) and return unless @user

    @form = ChangePasswordForm.new
  end

  def update
    redirect_to(account_path, notice: t('already_logged_in', scope: 'password_resets.new')) and return if current_user

    @token = params[:id]
    @user = User.find_by_reset_password_token(@token)

    redirect_to(edit_password_reset_path, alert: t('wrong_token', scope: 'password_resets.edit')) and return unless @user

    @form = ChangePasswordForm.from_params(params)
    ChangePassword.call(@form, @user) do
      on(:ok) { redirect_to(login_path, notice: t('success', scope: 'password_resets.update')) }
      on(:invalid) do
        flash.now[:alert] = t('error', scope: 'password_resets.update')
        render :edit
      end
    end
  end

  def unlock
    redirect_to(root_path, alert: t('logged_in_user', scope: 'password_resets.unlock')) and return if current_user

    @token = params[:id]
    @user = User.load_from_unlock_token(@token)

    redirect_to(root_path, alert: t('error', scope: 'password_resets.unlock')) and return unless @user

    @user.login_unlock!
    redirect_to(login_path, notice: t('success', scope: 'password_resets.unlock'))
  end
end
