class AddColumnAboutSuspendToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspend_reason, :integer, null: false, default: 0
    add_column :users, :suspended_on,   :date
    add_index  :users, :suspend_reason
  end
end
