# frozen_string_literal: true

# SessionsController provides logic for keeping User's session
class SessionsController < ApplicationController
  before_action :require_login, only: :destroy

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to(account_path, notice: t('success', scope: 'session.create'))
    else
      flash.now[:alert] = t('error', scope: 'session.create')
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: t('success', scope: 'session.destroy'))
  end
end
