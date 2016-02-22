# Question: question modeling
class Question < ActiveRecord::Base
  before_save :prefill_json_fields
  belongs_to :survey_template

  enum question_type: [:question_type_text, :question_type_rich_text,
                       :question_type_multiple_choice,
                       :question_type_multiple_select]

  def prefill_json_fields
    self.extras = '[]' if extras.blank?
    self.content = '[]' if content.blank?
  end
end
