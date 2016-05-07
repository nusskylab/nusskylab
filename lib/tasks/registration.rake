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
    tag_freq_table = {}
    tag_table = {}
    HashTag.all.each do |tag|
      tag_freq_table[tag.id] = 0
      tag_table[tag.id] = tag.content
    end
    users_vectors = {}
    match_making_user_ids = generate_user_ids_for_match_making
    all_registrations = Registration.where(user_id: match_making_user_ids)
    users = {}
    User.where(id: match_making_user_ids).each do |user|
      users[user.id] = user
    end
    fill_tag_frequency_table_and_users_vetors(
      all_registrations, tag_freq_table, users_vectors
    )
    users_tags = generate_users_tags(users_vectors, tag_table)
    similarity_table = {}
    users_vectors.each do |stu1_user_id, vec1|
      similarity_table[stu1_user_id] = {}
      users_vectors.each do |stu2_user_id, vec2|
        similarity_table[stu1_user_id][stu2_user_id] = compute_vector_cosine(vec1, vec2) unless stu2_user_id == stu1_user_id
      end
    end
    potential_teammates = {}
    similarity_table.each do |user_id, similarity_tbl|
      other_users = []
      similarity_tbl.each do |other_user_id, similarity|
        similarity = 0.0 if similarity.nan?
        other_users.append([users[other_user_id].user_name, similarity])
      end
      other_users.sort! { |a, b| a[1] <=> b[1] }
      potential_teammates[user_id] = other_users.last(10).reverse
    end
    write_results_to_csv(potential_teammates, users_tags, users)
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

  def generate_user_ids_for_match_making(user_type = 'pending_students')
    current_cohort = Time.now.year
    if user_type == 'pending_students'
      pending_students = Student.where(
        cohort: current_cohort, is_pending: false, team_id: nil
      )
    else
      fail ArgumentError, 'Unrecognized user type for match making'
    end
    pending_students.map(&:user_id)
  end

  def fill_tag_frequency_table_and_users_vetors(
    all_registrations, tag_freq_table, users_vectors)
    questions = {}
    if all_registrations.length > 0
      all_registrations[0].survey_template.questions.each do |q|
        questions[q.id] = q
      end
    else
      fail 'No registrations to run match making on'
    end
    all_registrations.each do |registration|
      response = registration.response_content
      response.each do |key, val|
        next unless questions[key.to_i] && questions[key.to_i].extras
        next unless JSON.parse(questions[key.to_i].extras)['for_registration']
        val.each do |tag_idx|
          tag_freq_table[tag_idx.to_i] += 1 unless tag_freq_table[tag_idx.to_i].nil?
        end
      end
    end
    all_registrations.each do |registration|
      users_vectors[registration.user_id] = {}
      response = registration.response_content
      response.each do |key, val|
        next unless questions[key.to_i] && questions[key.to_i].extras
        next unless JSON.parse(questions[key.to_i].extras)['for_registration']
        val.each do |tag_idx|
          users_vectors[registration.user_id][tag_idx.to_i] = Math.log2(
            all_registrations.length / (1 + tag_freq_table[tag_idx.to_i])
          )
        end
      end
    end
  end

  def generate_users_tags(users_vectors, tags_table)
    users_tags = {}
    users_vectors.each do |user_id, vec|
      tags = []
      vec.each do |tag_id, val|
        tags.append(tags_table[tag_id])
      end
      users_tags[user_id] = tags
    end
    users_tags
  end

  def write_results_to_csv(potential_teammates, users_tags, users)
    require 'csv'
    CSV.open('matches.csv', 'wb') do |csv|
      csv << [
        'Target User ID', 'User Name', 'Email', 'Match 1 ID', 'Match 1 Similarity',
        'Match 2 ID', 'Match 2 Similarity', 'Match 3 ID', 'Match 3 Similarity',
        'User\'s tags'
      ]
      potential_teammates.each do |user_id, matches|
        row = [user_id]
        row.append(users[user_id].user_name)
        row.append(users[user_id].email)
        matches.each do |match|
          row.concat(match)
        end
        row.append(users_tags[user_id])
        csv << row
      end
    end
  end
end
