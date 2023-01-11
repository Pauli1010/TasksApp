# frozen_string_literal: true

# RegistrationsController provides logic for signing up users
class RegistrationsController < ApplicationController
  layout 'login'
  skip_before_action :require_login

  def new
    @user = User.new
  end
  def create
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
