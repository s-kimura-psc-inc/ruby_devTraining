class Task < ApplicationRecord
  self.table_name = :tbl_task_infs
  
  validates :task_nm, presence: true, length: { maximum: 20 }
  validates :task, length: { maximum: 100 }
  
  
  # ユーザ削除に伴うタスクの削除
  #
  # @param user_id [String] ユーザID
  def self.destroy_user_task!(user_id)
    if user_id.present?
      where(personnel: user_id).delete_all
    end
  end
end
