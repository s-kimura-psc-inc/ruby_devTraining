class CreateTblTaskInfs < ActiveRecord::Migration[5.0]
  def change
    create_table :tbl_task_infs do |t|
      t.string :task_nm, null: false
      t.string :task
      t.column :label_cd, :'int4'
      t.string :deadline
      t.column :status_cd, :'int4'
      t.column :priority_cd, :'int4'
      t.string :personnel
      t.string :created_by
      t.string :updated_by
      
      t.timestamps
    end
  end
end
