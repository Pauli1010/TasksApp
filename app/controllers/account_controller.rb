# frozen_string_literal: true

# AccountController provides logic for maintaining User's own data
class AccountController < ApplicationController
  before_action :require_login

  def show; end

  def edit; end

  def update; end
end
