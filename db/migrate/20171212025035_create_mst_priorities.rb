class CreateMstPriorities < ActiveRecord::Migration[5.0]
  def change
    create_table :mst_priorities do |t|
      t.column :priority_cd, :'int4', null: false
      t.string :priority_nm, null: false
    end
    
    add_index :mst_priorities, :priority_cd, unique: true
  end
end
