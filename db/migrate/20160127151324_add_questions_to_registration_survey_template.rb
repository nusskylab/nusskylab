class AddQuestionsToRegistrationSurveyTemplate < ActiveRecord::Migration
  def up
    survey_template = SurveyTemplate.find_by(milestone_id: 1, survey_type: 3)
    return unless survey_template

    question = Question.new(
      title: 'Your level of interest in Orbital?',
      content: '["Definitely signing up.",' \
               '"Highly likely to be signing up.",' \
               '"Just interested at this point. Haven\'t decided.",' \
               '"Not interested / Unlikely to sign up."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Which level of achievement are you interested in?',
      content: '["Beginner (Восто́к; Vostok)",' \
               '"Intermediate (Project Gemini)",' \
               '"Advanced (Apollo 11)",' \
               '"Advanced with mentorship (Artemis)"]',
      instruction: 'Not sure of the correct level? Read '\
                'http://orbital.comp.nus.edu.sg/?p=45 for a rough guide.',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Will you be overseas for any period of time during the summer?',
      content: '["No, planning to stay in Singapore for the whole summer '\
                '(minus a short vacation)",' \
               '"Yes, for some portion (more than 2-3 days)",' \
               '"Yes, for almost the whole summer"]',
      instruction: 'Students who are overseas are ENCOURAGED to try Orbital, '\
                'even though they may have a more difficult time with '\
                'completing the project. This question is for our '\
                'administrative tracking purposes only.',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics. Start one topic with a hash',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: false
    )
    question.save
  end

  def down
    survey_template = SurveyTemplate.find_by(milestone_id: 1, survey_type: 3)
    survey_template.questions.each(&:destroy) if survey_template
  end
end
