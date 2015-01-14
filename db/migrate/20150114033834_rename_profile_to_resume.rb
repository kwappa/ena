class RenameProfileToResume < ActiveRecord::Migration
  def change
    if table_exists?(:user_profiles)
      rename_table(:user_profiles, :user_resumes)
    end
  end
end
