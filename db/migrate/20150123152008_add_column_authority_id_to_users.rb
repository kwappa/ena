class AddColumnAuthorityIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authority_id, :integer, null: false, default: 0
    add_index  :users, :authority_id
  end
end
