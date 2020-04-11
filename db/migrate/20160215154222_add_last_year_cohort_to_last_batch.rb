class AddLastYearCohortToLastBatch < ActiveRecord::Migration
  def up
    last_cohort = 2015
    Admin.all.each do |admin|
      admin.cohort = last_cohort
      admin.save
    end
    Adviser.all.each do |adviser|
      adviser.cohort = last_cohort
      adviser.save
    end
    Student.all.each do |student|
      student.cohort = last_cohort
      student.save
    end
    Team.all.each do |team|
      team.cohort = last_cohort
      team.save
    end
    Mentor.all.each do |mentor|
      mentor.cohort = last_cohort
      mentor.save
    end
    Tutor.all.each do |tutor|
      tutor.cohort = last_cohort
      tutor.save
    end
    Facilitator.all.each do |facilitator|
      facilitator.cohort = last_cohort
      facilitator.save
    end
    Milestone.all.each do |milestone|
      milestone.cohort = last_cohort
      milestone.save
    end
  end

  def down
  end
end
