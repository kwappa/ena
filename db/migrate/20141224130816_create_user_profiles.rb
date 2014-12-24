class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer  :user_id, null: false
      t.text     :body
      t.timestamps         null: false
    end

    add_index :user_profiles, :user_id
  end
end
