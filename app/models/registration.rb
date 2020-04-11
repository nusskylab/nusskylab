class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey_template

  def get_response_for_question(question_id)
    response_content[question_id.to_s] unless response_content.blank?
  end
end
