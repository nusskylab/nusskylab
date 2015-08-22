class Question < ActiveRecord::Base
  FORM_QUESTION_ID_PREFIX = 'questions['
  FROM_QUESTION_ID_SUFFIX = ']'

  belongs_to :survey_template

  enum question_type: [:question_type_text, :question_type_rich_text,
                       :question_type_multiple_choice]

  # TODO: move this method to helper instead as this is only related to views and controllers
  def get_question_id_for_form
    return FORM_QUESTION_ID_PREFIX + self.id.to_s + FROM_QUESTION_ID_SUFFIX
  end
end
