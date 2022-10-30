# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login

  # OVERWRITTEN SORCERY METHOD
  # Sets login path as a route for not authenticated user
  def not_authenticated
    redirect_to login_path
  end
end
