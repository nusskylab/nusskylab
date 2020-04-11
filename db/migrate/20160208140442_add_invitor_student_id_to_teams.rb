class AddInvitorStudentIdToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :invitor_student_id, :integer
  end

  def down
    remove_column :teams, :invitor_student_id, :integer
  end
end
