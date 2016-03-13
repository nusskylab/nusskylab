namespace :registration do
  desc 'Push all pending students to live in current cohort'
  task push_students_to_non_pending: :environment do
    current_cohort = Time.now.year
    Student.where(cohort: current_cohort, is_pending: true).each do |student|
      student.is_pending = false
      student.save
    end
  end
end
