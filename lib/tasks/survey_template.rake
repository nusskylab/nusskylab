namespace :survey_template do
  desc 'Migrate survey templates from previous cohort to current cohort. Requires you to first instantiate Milestones for the new cohort.'
  task migrate_from_prev_cohort: :environment do
    current_cohort = Time.now.year
    previous_cohort = current_cohort - 1
    milestones = Milestone.where(cohort: previous_cohort)
    milestones.each do |milestone|
      curr_milestone = Milestone.find_by(
        cohort: current_cohort, name: milestone.name
      )
      sts = milestone.survey_templates
      sts.each do |st|
        curr_st = st.dup
        curr_st.milestone_id = curr_milestone.id
        begin
          curr_st.save
          next unless curr_st.id
        rescue StandardError
          next
        end
        st.questions.each do |q|
          curr_q = q.dup
          print curr_st.id
          curr_q.survey_template_id = curr_st.id
          curr_q.save
        end
      end
    end
  end
end
