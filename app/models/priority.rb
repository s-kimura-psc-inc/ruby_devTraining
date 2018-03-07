class Priority < ApplicationRecord
  self.table_name = :mst_priorities
  
  # �D��x�Z���N�g�{�b�N�X�̑I�������擾����
  #
  # @return [Array] �擾�����I����
  def self.select_options
    options = select(:priority_cd, :priority_nm).order(:priority_cd).map do |priority_kubun|
      ["#{priority_kubun.priority_nm}", priority_kubun.priority_cd]
    end
    options
  end
end
