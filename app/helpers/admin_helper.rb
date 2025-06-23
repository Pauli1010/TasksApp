# frozen_string_literal: true

module AdminHelper
  def user_full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def user_name(user)
    user_full_name(user).presence || user.user_name.presence || user.email
  end

  def user_initials(user)
    "#{user.first_name&.first}#{user.last_name&.first}" ||
      user.user_name&.first.presence ||
      email.first
  end
end
