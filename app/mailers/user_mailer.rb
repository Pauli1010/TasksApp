# frozen_string_literal: true

class UserMailer < ApplicationMailer

  def activation_needed_email(user)
    @user = user
    @activation_url = activate_registration_url(@user.activation_token)
    mail(to: user.email, subject: t('user_mailer.activation_needed_email.subject', app_name: app_name))
  end

  def send_unlock_token_email
    @user = user
    @unlocking_url = unlock_password_reset_url(@user.activation_token)
    mail(to: user.email, subject: t('user_mailer.send_unlock_token_email.subject', app_name: app_name))
  end

  def reset_password_email
    @greeting = "Hi"

    mail to: "to@example.org", subject: t('user_mailer.reset_password_email.subject', app_name: app_name)
  end

  # Email is disabled in Sorcery initializer:
  #   user.activation_success_email_method_name = nil
  #   Needs to be enabled or removed in final project
  # def activation_success_email(user)
  #   @user = user
  #   mail(to: user.email, subject: "Your account is now activated")
  # end
end
