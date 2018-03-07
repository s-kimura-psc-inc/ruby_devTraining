module ApplicationHelper

  def menu_item_class(menu_controller_name, options = {})
    return {} if controller_name != menu_controller_name
    return { class: 'active' } if only_actions?(options[:only]) && not_except_actions?(options[:except])
    {}
  end

#  def validation_error_title(error_count)
#    return "#{error_count} 件のエラーが発生しました" if I18n.locale == :ja
#    "#{error_count} #{error_count < 2 ? 'error' : 'errors'} occurred"
#  end

  private

  def only_actions?(actions)
    return true if actions.blank?

    active = false

    actions.each do |only_action_name|
      if action_name == only_action_name
        active = true
        break
      end
    end

    active
  end

  def not_except_actions?(actions)
    return true if actions.blank?

    active = true

    actions.each do |except_action_name|
      if action_name == except_action_name
        active = false
        break
      end
    end

    active
  end
  
end
