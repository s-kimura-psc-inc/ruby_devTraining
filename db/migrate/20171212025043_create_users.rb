class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :crypted_password, null: false
      t.string :password_salt
      t.string :persistence_token
      t.string :user_nm
      t.column :authority_level, :'char(1)', null: false
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
