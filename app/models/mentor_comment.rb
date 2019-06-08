# MentorComment: MentorComment modeling
class MentorComment < ActiveRecord::Base
    validates :mentor_id, presence: true
    validates :survey_template_id, presence: true
    validates :target_team_id, uniqueness: {
      scope: :mentor_id,
      message: ' cannot submit duplicated feedback'
    }, if: :target_type_team?
  
    belongs_to :mentor
    belongs_to :target_team, foreign_key: :target_team_id, class_name: Team
    belongs_to :survey_template
  
    enum target_type: [:target_type_team]
  
    def get_response_for_question(question_id)
      response_content[question_id.to_s] unless response_content.blank?
    end
  end