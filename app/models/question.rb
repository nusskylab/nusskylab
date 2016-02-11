# Question: question modeling
class Question < ActiveRecord::Base
  belongs_to :survey_template

  enum question_type: [:question_type_text, :question_type_rich_text,
                       :question_type_multiple_choice,
                       :question_type_multiple_select]
end
