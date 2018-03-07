class Task < ApplicationRecord
  self.table_name = :tbl_task_infs
  
  # タスク一覧情報を取得する
  #
  # @param
  # @return [ActiveRecord::Result] 取得したデータ
  def self.task_records(params)
      sql = <<~SQL
      SELECT
        tti.id,
        ml.label_nm,
        tti.task_nm,
        tti.task,
        tti.deadline,
        ms.status_nm,
        mp.priority_nm,
        tti.created_by
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
        #{where_sql(params[:task_nm], params[:task], params[:label_cd])}
      ORDER BY
        tti.updated_at DESC
    SQL

    sql = ApplicationRecord.send(:sanitize_sql_array, [sql.gsub(/\s+/, ' ')])
    ApplicationRecord.connection.select_all(sql)
  end
  
  # タスク詳細情報を取得する
  #
  # @param
  # @return [ActiveRecord::Result] 取得したデータ
  def self.task_record(id)
      sql = <<~SQL
      SELECT
        ml.label_nm,
        tti.task_nm,
        tti.task,
        tti.deadline,
        ms.status_nm,
        mp.priority_nm,
        tti.created_by
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
      WHERE tti.id = #{id}
    SQL

    sql = ApplicationRecord.send(:sanitize_sql_array, [sql.gsub(/\s+/, ' ')])
    ApplicationRecord.connection.select_all(sql)
  end
  
  # タスク一覧情報取得する際の絞込み条件(WHERE句)を生成する
  #
  # @param task_nm [String] タスク名
  # @param task [String] タスク
  # @param label_cd [int] ラベルコード
  # @return [String] WHERE句の文字列
  def self.where_sql(task_nm, task, label_cd)
    where_bool = false
    where_conditions = ''
    
    if task_nm.present?
      where_conditions = " WHERE tti.task_nm like '" + task_nm + "%'"
      where_bool = true
    end
    
    if task.present?
      if where_bool == "false"
        where_conditions = " WHERE tti.task like '%" + task + "%'"
        where_bool = true
      else
        where_conditions += " AND tti.task like '%" + task + "%'"
      end
    end

    if label_cd.present?
      if where_bool == "false"
        where_conditions = " WHERE ml.label_cd = " + label_cd
        where_bool = true
      else
        where_conditions += " AND ml.label_cd = " + label_cd
      end
    end
    where_conditions
  end
  private_class_method :where_sql
  
end
