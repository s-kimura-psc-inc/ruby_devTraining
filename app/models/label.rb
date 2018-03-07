class Label < ApplicationRecord
  self.table_name = :mst_labels

  # ラベルセレクトボックスの選択肢を取得する
  #
  # @return [Array] 取得した選択肢
  def self.select_options
    options = select(:label_cd, :label_nm).order(:label_cd).map do |label_kubun|
      ["#{label_kubun.label_nm}", label_kubun.label_cd]
    end
    options
  end
end
