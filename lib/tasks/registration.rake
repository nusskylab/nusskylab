namespace :registration do
  desc 'Push all pending students to live in current cohort'
  task push_students_to_non_pending: :environment do
    current_cohort = Time.now.year
    Student.where(cohort: current_cohort, is_pending: true).each do |student|
      student.is_pending = false
      student.save
    end
  end

  desc 'Match students without teams yet'
  task match_students_without_teams: :environment do
    current_cohort = Time.now.year
    pending_students = Student.where(cohort: current_cohort, is_pending: true)
    students_vectors = {}
    tag_freq_table = {}
    HashTag.all.each do |tag|
      tag_freq_table[tag.id] = 0
    end
    students_user_ids = pending_students.map(&:user_id)
    questions = {}
    all_registrations = Registration.where(user_id: students_user_ids)
    if all_registrations.length > 0
      all_registrations[0].survey_template.questions.each do |q|
        questions[q.id] = q
      end
    end
    all_registrations.each do |registration|
      response = JSON.parse(registration.response_content)
      response.each do |key, val|
        if questions[key.to_i] && questions[key.to_i].extras
          if JSON.parse(questions[key.to_i].extras)[:for_registration]
            val.each do |tag_idx|
              tag_freq_table[tag_idx.to_i] = tag_freq_table[tag_idx.to_i] + 1 if !tag_freq_table[tag_idx.to_i].nil?
            end
          end
        end
      end
    end
    all_registrations.each do |registration|
      students_vectors[registration.user_id] = {}
      response = JSON.parse(registration.response_content)
      response.each do |key, val|
        if questions[key.to_i] && questions[key.to_i].extras
          if JSON.parse(questions[key.to_i].extras)[:for_registration]
            val.each do |tag_idx|
              students_vectors[registration.user_id][tag_idx.to_i] = 1.0 * all_registrations.length / tag_freq_table[tag_idx.to_i]
            end
          end
        end
      end
    end
    similarity_table = {}
    students_vectors.each do |stu1_user_id, vec1|
      similarity_table[stu1_user_id] = {}
      students_vectors.each do |stu2_user_id, vec2|
        # calculate vector cosine
        similarity_table[stu1_user_id][stu2_user_id] = compute_vector_cosine(vec1, vec2) if stu2_user_id != stu1_user_id
      end
    end
    puts similarity_table
  end

  def compute_vector_cosine(vec1, vec2)
    upper = 0.0
    vec1.each do |tag_idx, val|
      upper += vec1[tag_idx] * vec2[tag_idx] unless vec2[tag_idx].nil?
    end
    lower1 = 0.0
    vec1.each do |_, val|
      lower1 += val * val
    end
    lower2 = 0.0
    vec2.each do |_, val|
      lower2 += val * val
    end
    lower1 = Math.sqrt(lower1)
    lower2 = Math.sqrt(lower2)
    upper / (lower1 * lower2)
  end
end
