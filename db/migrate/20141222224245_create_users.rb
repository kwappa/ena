class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,               null: false
      t.string :email,              null: false
      t.string :nick,               null: false
      t.string :member_number
      t.string :screen_name
      t.string :screen_name_kana
      t.string :encrypted_password, null: false

      # devise
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps                  null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :name,                 unique: true
    add_index :users, :nick,                 unique: true
    add_index :users, :member_number,        unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
