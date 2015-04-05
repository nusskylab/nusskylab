class AddTeamToStudent < ActiveRecord::Migration
  def change
    add_reference :students, :team, index: true
    add_foreign_key :students, :teams
  end
end
