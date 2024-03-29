# frozen_string_literal: true

# RegistrationsController provides logic for signing up users
class RegistrationsController < ApplicationController
  layout 'login'
  skip_before_action :require_login

  def new
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registrations.new')) and return if current_user

    @form = RegistrationForm.new
  end

  def create
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registrations.new')) and return if current_user

    @form = RegistrationForm.from_params(params)

    RegisterUser.call(@form) do
      on(:ok) { redirect_to(login_path, notice: t('success', scope: 'registrations.create')) }
      on(:invalid) do
        flash.now[:alert] = t('error', scope: 'registrations.create')
        render :new
      end
    end
  end

  def activate
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registrations.new')) and return if current_user

    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, notice: t('success', scope: 'registrations.activate'))
    else
      redirect_to(root_path, alert: t('error', scope: 'registrations.activate'))
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
