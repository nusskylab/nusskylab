# MentorMatchings: mentor modeling
class MentorMatchings < ActiveRecord::Base
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
    myMentors = MentorMatchings.create([
      { :team_id => team.id, :mentor_id => User.find(choices[0]).id, :choice_ranking => 1, :mentor_accepted => false, :cohort => cohort },
      { :team_id => team.id, :mentor_id => User.find(choices[1]).id, :choice_ranking => 2, :mentor_accepted => false, :cohort => cohort },
      { :team_id => team.id, :mentor_id => User.find(choices[2]).id, :choice_ranking => 3, :mentor_accepted => false, :cohort => cohort }
    ])
    MentorMatchings.transaction do
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
  MentorMatchings.transaction do
    begin  
      for i in 0..2
        MentorMatchings.where(:id => teamsMentorMatchings[i]).update_all(:mentor_id => User.find(choices[i]), :choice_ranking => i + 1, :mentor_accepted => false, :cohort => cohort)
      end
      true
    rescue  => ex
      puts ex
      raise ActiveRecord::Rollback, ex
      false
    end
  end
end 


end