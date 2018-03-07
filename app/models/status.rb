class Status < ApplicationRecord
  self.table_name = :mst_statuses

  # ステータスセレクトボックスの選択肢を取得する
  #
  # @return [Array] 取得した選択肢
  def self.select_options
    options = select(:status_cd, :status_nm).order(:status_cd).map do |status_kubun|
      ["#{status_kubun.status_nm}", status_kubun.status_cd]
    end
    options
  end
end
