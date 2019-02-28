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

  belongs_to :team_id, foreign_key: :team_id, class_name: Team
  belongs_to :mentor_id, foreign_key: :mentor_id, class_name: User
  
  def self.match_mentor(team, choices, cohort)
    myMentors = MentorMatchings.create([
      { :team_id => team, :mentor_id => User.find(choices[0]), :choice_ranking => 1, :mentor_accepted => false, :cohort => cohort },
      { :team_id => team, :mentor_id => User.find(choices[1]), :choice_ranking => 2, :mentor_accepted => false, :cohort => cohort },
      { :team_id => team, :mentor_id => User.find(choices[2]), :choice_ranking => 3, :mentor_accepted => false, :cohort => cohort }
    ])
    MentorMatchings.transaction do
      begin  
        myMentors[0].save!
        myMentors[1].save!
        myMentors[2].save!
        true
      rescue  => ex
          raise ActiveRecord::Rollback, ex
          false
      end
    end
  end 

end