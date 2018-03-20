module TasksHelper
  
  # ソート処理
  def sortable(column, title = nil)    
    title ||= column.titleize
    
    case column
      when '期限' then column = 'deadline'
      when '優先度' then column = 'priority_cd'
      else column = 'updated_at'
    end
    
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}
  end
  
end
