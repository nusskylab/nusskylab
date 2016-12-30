# Question: question modeling
class Question < ActiveRecord::Base
  before_validation :prefill_json_fields
  validate :validate_json_fields

  belongs_to :survey_template

  enum question_type: [:question_type_text, :question_type_rich_text,
                       :question_type_multiple_choice,
                       :question_type_multiple_select]

  def prefill_json_fields
    self.extras = '{}' if extras.blank?
    self.content = '[]' if content.blank?
  end

  def validate_json_fields
    begin
      JSON.parse(extras)
    rescue JSON::ParserError
      errors.add(:extras, 'must be a valid JSON string')
    end
    begin
      JSON.parse(content)
    rescue JSON::ParserError
      errors.add(:content, 'must be a valid JSON string')
    end
  end
end
