# frozen_string_literal: true

# SessionsController provides logic for keeping User's session
class SessionsController < ApplicationController
  layout 'login'
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registration.new')) and return if current_user
  end
  def create
    redirect_to(root_path, notice: t('already_logged_in', scope: 'registration.new')) and return if current_user

    @user = User.find_by(email: params[:email])

    if @user&.activation_state_pending?
      redirect_to(root_path, notice: t('cannot_login', scope: 'session.create'))
    elsif login(params[:email], params[:password])
      redirect_to(account_path, notice: t('success', scope: 'session.create'))
    else
      flash.now[:alert] = t('error', scope: 'session.create')
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(login_path, notice: t('success', scope: 'session.destroy'))
  end
end
