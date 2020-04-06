# MentorMatchings: mentor modeling
class MentorMatching < ActiveRecord::Base
  validates :team_id, presence: true, uniqueness: {
    scope: :mentor_id,
    message: "Cannot have 2 similar mentor in a team"
  }
  validates :mentor_id, presence: true
  validates :choice_ranking, presence: true, uniqueness: {
    scope: :team_id,
    message: "Can only have 1 option for either 1st, 2nd and 3rd"
  }

  belongs_to :team, foreign_key: :team_id, class_name: Team
  belongs_to :mentor, foreign_key: :mentor_id, class_name: Mentor

  def self.match_mentor(team, choices, cohort)
    myMentors = MentorMatching.create([
       { :team_id => team.id, :mentor_id => Mentor.find(choices[0]).id, :choice_ranking => 1, :mentor_accepted => false, :cohort => cohort },
       { :team_id => team.id, :mentor_id => Mentor.find(choices[1]).id, :choice_ranking => 2, :mentor_accepted => false, :cohort => cohort },
       { :team_id => team.id, :mentor_id => Mentor.find(choices[2]).id, :choice_ranking => 3, :mentor_accepted => false, :cohort => cohort }
                                       ])
    MentorMatching.transaction do
      begin
        myMentors[0].save!
        myMentors[1].save!
        myMentors[2].save!
        true
      rescue  => ex
        puts ex
        raise ActiveRecord::Rollback, ex
        false
      end
    end
  end

  def self.edit_mentor_preferences(team, choices, cohort, teamsMentorMatchings)
    MentorMatching.transaction do
      begin
        for i in 0..2
          MentorMatching.where(:id => teamsMentorMatchings[i]).update_all(:mentor_id => Mentor.find(choices[i]), :choice_ranking => i + 1, :mentor_accepted => false, :cohort => cohort)
        end
        true
      rescue  => ex
        puts ex
        raise ActiveRecord::Rollback, ex
        false
      end
    end
  end

  def self.to_csv(**options)
    require 'csv'
    if options[:cohort].nil?
      exported_mentor_matchings = all
    else
      exported_mentor_matchings = where(cohort: options[:cohort])
      options.delete(:cohort)
    end

    attributes = %w{team_name mentor_name mentor_accepted choice_ranking cohort}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      exported_mentor_matchings.each do |mentor_matching|
          csv << attributes.map{ |attr|
            if attr.eql?"mentor_name"
              mentor_matching.mentor.user.user_name
            elsif attr.eql?"team_name"
              mentor_matching.team.team_name
            else
              mentor_matching.send(attr)
            end
          }
      end
    end
  end

end
