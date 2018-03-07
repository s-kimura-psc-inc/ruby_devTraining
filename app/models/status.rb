class Status < ApplicationRecord
  self.table_name = :mst_statuses

  # �X�e�[�^�X�Z���N�g�{�b�N�X�̑I�������擾����
  #
  # @return [Array] �擾�����I����
  def self.select_options
    options = select(:status_cd, :status_nm).order(:status_cd).map do |status_kubun|
      ["#{status_kubun.status_nm}", status_kubun.status_cd]
    end
    options
  end
end
