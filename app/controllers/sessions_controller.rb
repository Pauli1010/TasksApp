# frozen_string_literal: true

# SessionsController provides logic for keeping User's session
class SessionsController < ApplicationController
  layout 'login'
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registrations.new')) and return if current_user
  end
  def create
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registrations.new')) and return if current_user

    @user = User.find_by(email: params[:email])
    if @user&.activation_state_pending?
      redirect_to(root_path, notice: t('cannot_login', scope: 'sessions.create'))
    elsif login(params[:email], params[:password], params[:remember_me])
      redirect_to(account_path, notice: t('success', scope: 'sessions.create'))
    else
      redirect_to(login_path, alert: t('error', scope: 'sessions.create'))
    end
  end

  def destroy
    logout
    redirect_to(login_path, notice: t('success', scope: 'sessions.destroy'))
  end
end
