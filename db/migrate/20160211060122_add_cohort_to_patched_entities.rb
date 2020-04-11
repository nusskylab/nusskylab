class AddCohortToPatchedEntities < ActiveRecord::Migration
  def up
    add_column :admins, :cohort, :integer
    add_column :advisers, :cohort, :integer
    add_column :students, :cohort, :integer
    add_column :teams, :cohort, :integer
    add_column :mentors, :cohort, :integer
    add_column :tutors, :cohort, :integer
    add_column :facilitators, :cohort, :integer
    add_column :milestones, :cohort, :integer
  end

  def down
    remove_column :admins, :cohort, :integer
    remove_column :advisers, :cohort, :integer
    remove_column :students, :cohort, :integer
    remove_column :teams, :cohort, :integer
    remove_column :mentors, :cohort, :integer
    remove_column :tutors, :cohort, :integer
    remove_column :facilitators, :cohort, :integer
    remove_column :milestones, :cohort, :integer
  end
end
