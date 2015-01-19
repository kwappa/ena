class CreateUserTagAndTagging < ActiveRecord::Migration
  def change
    create_table :user_tags do |t|
      t.string :name,         null: false
      t.string :search_hash,  null: false

      t.timestamps            null: false
    end

    add_index :user_tags, :search_hash, unique: true

    create_table :user_taggings do |t|
      t.integer :user_id,     null: false
      t.integer :user_tag_id, null: false
    end

    add_index :user_taggings, :user_id
    add_index :user_taggings, :user_tag_id
    add_index :user_taggings, [:user_id, :user_tag_id], unique: true
  end
end
