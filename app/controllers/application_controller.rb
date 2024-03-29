# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Rectify::ControllerHelpers
  before_action :require_login

  # OVERWRITTEN SORCERY METHOD
  # Sets login path as a route for not authenticated user
  def not_authenticated
    redirect_to login_path, alert: t('flash_messages.login_required')
  end
end
