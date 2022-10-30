# frozen_string_literal: true

module ApplicationHelper
  def menu_active?(controller, action = nil)
    'active' if (action && controller == controller_name && action == action_name) || (!action && controller == controller_name)
  end

  def user_avatar(user)
    initials = "#{user.first_name[0] if user.first_name.present?}#{user.last_name[0] if user.last_name.present?}"
    tag.div initials, class: 'avatar'
  end
end
