class CreateMstLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :mst_labels do |t|
      t.column :label_cd, :'int4', null: false
      t.string :label_nm, null: false
    end
    
    add_index :mst_labels, :label_cd, unique: true
  end
end
