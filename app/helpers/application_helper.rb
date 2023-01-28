# frozen_string_literal: true

module ApplicationHelper
  def menu_active?(controller, action = nil)
    'active' if (action && controller == controller_name && action == action_name) || (!action && controller == controller_name)
  end

  def user_avatar(user)
    initials = "#{user.first_name[0] if user.first_name.present?}#{user.last_name[0] if user.last_name.present?}"
    tag.div initials, class: 'avatar'
  end

  def table_sorting(model, attribute, controller = nil, param = {})
    selected = params[:sort_by] == attribute
    ord = selected && params[:ord] && params[:ord] == 'ASC' ? 'DESC' : 'ASC'
    controller = controller.presence || controller_name
    header_name = t("activerecord.attributes.#{model}.headers.#{attribute}")
    link_to({ controller: controller, action: :index, sort_by: attribute, ord: ord },
            title: t('views.shared.sort'), class: "sort-table #{selected ? 'selected' : nil}") do
      (header_name +
        (selected ?
           ord == 'DESC' ?
             bootstrap_icon('caret-up-fill', width: 12, height: 12, fill: '#ffffff', class: 'sort-svg', title: t('helpers.order.desc'))
             : bootstrap_icon('caret-down-fill', width: 12, height: 12, fill: '#ffffff', class: 'sort-svg', title: t('helpers.order.asc'))
           : '')
      ).html_safe
    end
  end

  # Helper method for assigning numbers on list
  def ln(i)
    i + 1
  end

  def yes_no_icon(val)
    if val
      bootstrap_icon 'check-circle-fill', width: 12, height: 12, class: 'text-success', 'data-toggle': 'tooltip', title: t('booleans.question.true')
    else
      bootstrap_icon "x-circle-fill", width: 12, height: 12, class: 'text-dark', 'data-toggle': 'tooltip', title: t('booleans.question.true')
    end
  end

  def time_left(time)
      t(time.future? ? 'time_left' : 'past_time', scope: 'helpers', time: distance_of_time_in_words(time, Date.current))
  end

  def link_to_edit(item, controller = nil)
    controller = controller.presence || controller_name
    link_to({ controller: controller, action: :edit, id: item.id }, title: t('views.shared.edit'), class: 'btn btn-xs btn-info') do
      bootstrap_icon 'pencil', width: 12, height: 12, fill: '#ffffff'
    end
  end

  def link_to_delete(item, controller = nil)
    return if item.respond_to?(:destroyable?) && !item.destroyable?

    controller = controller.presence || controller_name
    link_to({ controller: controller, action: :destroy, id: item.id }, method: :delete, title: t('views.shared.delete'), data: { confirm: t('helpers.confirm') }, class: 'btn btn-xs btn-danger') do
      bootstrap_icon 'trash', width: 12, height: 12, fill: '#ffffff'
    end
  end
end
