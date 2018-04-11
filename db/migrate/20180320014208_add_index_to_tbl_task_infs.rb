class AddIndexToTblTaskInfs < ActiveRecord::Migration[5.0]
  def change
      add_index :tbl_task_infs, :personnel, :name => 'idx_tbl_task_infs_01'
  end
end
