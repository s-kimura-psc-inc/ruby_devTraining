module ApplicationHelper

  def menu_item_class(menu_controller_name, options = {})
    return {} if controller_name != menu_controller_name
    return { class: 'active' } if only_actions?(options[:only]) && not_except_actions?(options[:except])
    {}
  end

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
