module TasksHelper
  
  #期限（日付型）をYYYY/MM/DD形式の文字列で表示する
  def dt_format(deadline)
    result = ""
    if deadline.present?
      result = deadline.strftime("%Y/%m/%d")
    end
    result
  end
  
end
