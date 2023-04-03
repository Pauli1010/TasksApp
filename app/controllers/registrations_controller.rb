# frozen_string_literal: true

# RegistrationsController provides logic for signing up users
class RegistrationsController < ApplicationController
  layout 'login'
  skip_before_action :require_login

  def new
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registration.new')) and return if current_user

    @user = User.new
  end
  def create
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registration.new')) and return if current_user

    @user = User.new(user_params)

    if @user.save
      redirect_to(login_path, notice: t('success', scope: 'registration.create'))
    else
      flash.now[:alert] = t('error', scope: 'registration.create')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
