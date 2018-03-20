class Task < ApplicationRecord
  self.table_name = :tbl_task_infs
  
  validates :task_nm, presence: true, length: { maximum: 20 }
  validates :task, length: { maximum: 100 }
  
  # �^�X�N�ꗗ�����擾����
  #
  # @param
  # @return [ActiveRecord::Result] �擾�����f�[�^
  def self.task_records(params, sort)
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
        #{where_sql(params[:task_nm], params[:status_cd])}
      ORDER BY
        tti.#{sort}
    SQL
    
    if params[:task_nm].present?
      sql = ApplicationRecord.send(:sanitize_sql_array, [sql.gsub(/\s+/, ' '), params[:task_nm] + "%"])
    else
      sql = ApplicationRecord.send(:sanitize_sql_array, [sql.gsub(/\s+/, ' ')])
    end
    ApplicationRecord.connection.select_all(sql)
  end
  
  # �^�X�N�ڍ׏����擾����
  #
  # @param
  # @return [ActiveRecord::Result] �擾�����f�[�^
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
  
  # �^�X�N�ꗗ���擾����ۂ̍i���ݏ���(WHERE��)�𐶐�����
  #
  # @param task_nm [String] �^�X�N��
  # @param task [String] �^�X�N
  # @param label_cd [int] ���x���R�[�h
  # @return [String] WHERE��̕�����
  def self.where_sql(task_nm, status_cd)
    where_conditions = ''
    
    if task_nm.present?
      where_conditions = " WHERE tti.task_nm like ?"
    end
    
    if status_cd.present?
      if where_conditions == ''
        where_conditions = " WHERE tti.status_cd = " + status_cd
      else
        where_conditions += " AND tti.status_cd = " + status_cd
      end
    end
    where_conditions
  end
  private_class_method :where_sql
end
