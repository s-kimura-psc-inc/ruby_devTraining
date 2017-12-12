class CreateMstStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :mst_statuses do |t|
      t.column :status_cd, :'int4', null: false
      t.string :status_nm, null: false
    end
    
    add_index :mst_statuses, :status_cd, unique: true
  end
end
