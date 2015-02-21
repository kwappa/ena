class AddColumnOccupationIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :occupation_id, :integer, null: false, default: 0
    add_index  :users, :occupation_id
  end
end
