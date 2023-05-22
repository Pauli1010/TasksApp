# frozen_string_literal: true

# AccountController provides logic for maintaining User's own data
class AccountController < ApplicationController
  def show; end

  def edit
    @form = AccountForm.new
  end

  def update
    @form = AccountForm.from_params(params)

    UpdateAccount.call(@form, current_user) do
      on(:ok) {
        redirect_to(account_path, notice: t('success', scope: 'account.update'))
      }
      on(:invalid) {
        flash.now[:alert] = t('error', scope: 'account.update')
        render :edit
      }
    end
  end
end
