# frozen_string_literal: true

module ApplicationHelper
  def menu_is_active(controller, action = nil)
    'active' if controller == controller_name && ((action && action == action_name) || !action)
  end

  def user_avatar(user)
    tag.div user.initials.capitalize, class: 'avatar'
  end

  def table_sorting(model, attribute, controller = controller_name)
    selected = params[:sort_by] == attribute
    ord, icon = ordering_elements(params[:ord])
    url = { controller: controller, action: :index, sort_by: attribute, ord: ord }
    link_to(url, title: t('views.shared.sort'), class: "sort-table #{'selected' if selected}") do
      (t("activerecord.attributes.#{model}.headers.#{attribute}") + icon).html_safe
    end
  end

  def ordering_elements(param)
    param == 'ASC' ? ['DESC', icon_up] : ['ASC', icon_down]
  end

  def icon_up
    default_bootstrap_icon(
      'caret-up-fill',
      {
        class: 'sort-svg',
        title: t('helpers.order.desc')
      }
    )
  end

  def icon_down
    default_bootstrap_icon(
      'caret-down-fill',
      {
        class: 'sort-svg',
        title: t('helpers.order.asc')
      }
    )
  end

  # Helper method for assigning numbers on list
  def ln(index)
    index + 1
  end

  def yes_no_icon(val)
    default_bootstrap_icon(
      val ? 'check-circle-fill' : 'x-circle-fill',
      {
        class: 'text-success',
        title: t(val, scope: 'booleans.question'),
        data: { toggle: 'tooltip' }
      }
    )
  end

  def link_to_new(params = {}, controller = controller_name)
    url = { controller: controller, action: :new }.merge(params)
    link_to(url, title: t("views.shared.add_new.#{controller.singularize}"), class: 'btn btn-xs btn-success') do
      default_bootstrap_icon 'plus'
    end
  end

  def link_to_edit(item, controller = controller_name)
    url = { controller: controller, action: :edit, id: item.id }
    link_to(url, title: t('views.shared.edit'), class: 'btn btn-xs btn-info') do
      default_bootstrap_icon 'pencil'
    end
  end

  def link_to_delete(item, controller = controller_name)
    return if item.respond_to?(:destroyable?) && !item.destroyable?

    url = { controller: controller, action: :destroy, id: item.id }
    link_to(url,
            method: :delete,
            title: t('views.shared.delete'),
            data: { confirm: t('helpers.confirm') },
            class: 'btn btn-xs btn-danger') do
      default_bootstrap_icon 'trash'
    end
  end

  def default_bootstrap_icon(icon, options = {})
    bootstrap_icon(
      icon,
      width: 12,
      height: 12,
      fill: options[:fill].presence || '#ffffff',
      class: options[:class],
      title: options[:title],
      'data-toggle': options.dig(:data, :toggle)
    )
  end
end
