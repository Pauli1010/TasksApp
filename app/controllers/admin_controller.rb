# frozen_string_literal: true

# AdminController provides logic for all the Controllers
# that are in the Admin namespace
class AdminController < ApplicationController
  before_action :require_admin
  helper_method :items, :item

  def index; end
  def show; end
  def new; end
  def create; end
  def edit; end
  def update; end
  def destroy; end

  private

  def require_admin
    redirect_to root_path, alert: t('flash_messages.admin_required') and return unless current_user.admin?
  end

  def default_redirect_path
    root_path
  end
end
