class CreateTableTeamsAndAssignments < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string     :name,          null: false
      t.text       :description
      t.date       :organized_on
      t.date       :disbanded_on
      t.timestamps                 null: false
    end

    add_index :teams, :updated_at
    add_index :teams, :organized_on
    add_index :teams, :disbanded_on

    create_table :assignments do |t|
      t.integer     :team_id,      null: false
      t.integer     :user_id,      null: false
      t.integer     :role_id,      null: false
      t.date        :assigned_on,  null: false
      t.date        :withdrawn_on
      t.timestamps                 null: false
    end

    add_index :assignments, :team_id
    add_index :assignments, :user_id
    add_index :assignments, :assigned_on
    add_index :assignments, :withdrawn_on
  end
end
