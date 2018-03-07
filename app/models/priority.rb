class Priority < ApplicationRecord
  self.table_name = :mst_priorities
  
  # 優先度セレクトボックスの選択肢を取得する
  #
  # @return [Array] 取得した選択肢
  def self.select_options
    options = select(:priority_cd, :priority_nm).order(:priority_cd).map do |priority_kubun|
      ["#{priority_kubun.priority_nm}", priority_kubun.priority_cd]
    end
    options
  end
end
