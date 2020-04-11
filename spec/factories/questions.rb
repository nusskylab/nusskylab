FactoryGirl.define do
  factory :question do
    title 'Question 1'
    instruction 'Please answer the question'
    content nil
    question_type 0
    survey_template nil
    extras nil
  end
end
