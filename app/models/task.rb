class Task < ApplicationRecord
  self.table_name = :tbl_task_infs
  
  validates :task_nm, presence: true, length: { maximum: 20 }
  validates :task, length: { maximum: 100 }
  
  # タスク一覧情報を取得する
  #
  # @param user_id [String] ユーザID
  def self.user_task_lisk(login)
      sql = <<~SQL
      SELECT
        tti.id,
        ml.label_nm,
        tti.task_nm,
        tti.task,
        tti.deadline,
        ms.status_nm,
        mp.priority_nm,
        tti.personnel
      FROM
        #{table_name} tti
          LEFT OUTER JOIN #{Label.table_name} ml ON (
            tti.label_cd = ml.label_cd
          )
          LEFT OUTER JOIN #{Status.table_name} ms ON (
            tti.status_cd = ms.status_cd
          )
          LEFT OUTER JOIN #{Priority.table_name} mp ON (
            tti.priority_cd = mp.priority_cd
          )
      WHERE
         tti. personnel = '#{login}'
      ORDER BY
        tti.updated_at DESC
    SQL

    sql = ApplicationRecord.send(:sanitize_sql_array, [sql.gsub(/\s+/, ' ')])
    ApplicationRecord.connection.select_all(sql)
  end
  
  # ユーザ削除に伴うタスクの削除
  #
  # @param user_id [String] ユーザID
  def self.destroy_user_task!(user_id)
    if user_id.present?
      where(personnel: user_id).delete_all
    end
  end
end
