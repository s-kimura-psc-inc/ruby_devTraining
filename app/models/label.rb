class Label < ApplicationRecord
  self.table_name = :mst_labels

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
