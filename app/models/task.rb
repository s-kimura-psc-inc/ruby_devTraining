class Task < ApplicationRecord
  self.table_name = :tbl_task_infs
  
  validates :task_nm, presence: true, length: { maximum: 20 }
  validates :task, length: { maximum: 100 }
  
  
  # ���[�U�폜�ɔ����^�X�N�̍폜
  #
  # @param user_id [String] ���[�UID
  def self.destroy_user_task!(user_id)
    if user_id.present?
      where(personnel: user_id).delete_all
    end
  end
end
