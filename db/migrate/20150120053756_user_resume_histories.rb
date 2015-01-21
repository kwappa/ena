class UserResumeHistories < ActiveRecord::Migration
  def change
    create_table :user_resume_histories do |t|
      t.integer   :user_id,    null: false
      t.text      :diff,       null: false, default: ''
      t.timestamp :updated_at, null: false
    end

    add_index :user_resume_histories, [:user_id, :updated_at]
  end
end
