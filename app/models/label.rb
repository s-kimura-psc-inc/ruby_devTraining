class Label < ApplicationRecord
  self.table_name = :mst_labels

  validates :label_cd, presence: true, uniqueness: true, numericality: true, length: { maximum: 4 }
  validates :label_nm, presence: true, length: { maximum: 20 }
  

  # ���x���ꗗ�p�ɏ����擾����(�^�X�N���e�[�u���ɐݒ肳��Ă��郉�x���̌������擾����)
  def self.label_list
      sql = <<~SQL
      SELECT
        ml.id,
        ml.label_cd,
        ml.label_nm,
        tti.l_cnt
      FROM
        #{table_name} ml
          LEFT OUTER JOIN (
            SELECT label_cd,count(label_cd) l_cnt
            FROM #{Task.table_name}
            GROUP BY label_cd
          ) tti ON (
             ml.label_cd = tti.label_cd
          )
      ORDER BY
        ml.label_cd
    SQL

    sql = ApplicationRecord.send(:sanitize_sql_array, [sql.gsub(/\s+/, ' ')])
    ApplicationRecord.connection.select_all(sql)
  end

  # ���x���Z���N�g�{�b�N�X�̑I�������擾����
  #
  # @return [Array] �擾�����I����
  def self.select_options
    options = select(:label_cd, :label_nm).order(:label_cd).map do |label_kubun|
      ["#{label_kubun.label_nm}", label_kubun.label_cd]
    end
    options
  end
end
