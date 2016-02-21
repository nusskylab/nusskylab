class SplitRegistrationTagsQuestion < ActiveRecord::Migration
  def up
    milestone = Milestone.find_by(name: 'Milestone 1', cohort: 2016)
    survey_template = SurveyTemplate.find_by(milestone_id: milestone.id, survey_type: 3)
    questions = Question.where(survey_template_id: survey_template.id, question_type: 3)
    questions.each(&:destroy)

    question = Question.new(
      title: 'Your interested topics(Programming Language).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=language", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(Web Framework or Mobile).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?labels=web_framework,platform", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(IDE or text editor).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=ide", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(E-Commerce).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=ecommerce", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(Cloud).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=cloud", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(Purpose).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=purpose", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(Embedded system).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=embedded_system", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(Game framework).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=game_framework", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(CMS).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=cms", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Your interested topics(Audience).',
      content: '[]',
      instruction: 'Select tags that you are interested in',
      extras: '{"remote-api": "/tags?label=audience", "callback-action": "select2", "remote": "true"}',
      question_type: 3,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save
  end

  def down
  end
end
