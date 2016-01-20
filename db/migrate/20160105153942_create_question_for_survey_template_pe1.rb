class CreateQuestionForSurveyTemplatePe1 < ActiveRecord::Migration
  def up
    survey_template = SurveyTemplate.find_by(milestone_id: 1, survey_type: 1)

    question = Question.new(
      title: 'The project should serve some user needs. Is it clear who would benefit from the project?',
      content: '["Strongly Disagree",' \
               '"Disagree",' \
               '"Neutral",' \
               '"Agree",' \
               '"Strongly Agree"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Is the problem well defined? Is it clear what need the app is trying to satisfy?' \
             ' Is there a real need to solve the problem? Please grade this with respect to the group of users' \
             ' specified. Be broad in deciding what a problem is. It can be to do something not done before, to' \
             ' do something better, faster, cheaper, or to provide entertainment, fun, etc.',
      content: '["The project appears to be trying to do something, but I am not sure what it is.",' \
               '"I can roughly see what problem is.",' \
               '"There is clearly a problem, but it is unclear that it really needs to be solved.",' \
               '"There is clearly a problem and it is likely that solving it would be useful.",' \
               '"The problem is real. There is a real need for such an project."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Does the project solve the most important aspects of the problem?',
      content: '["The project does not really solve the problem.",' \
               '"The project would provide a minimal solution to the problem.",' \
               '"The project would provide an average solution to the problem.",' \
               '"The project would a good solution to the most important aspects of the problem.",' \
               '"The project would solve the problem, and creatively too!"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please provide feedback to the project team on the problem they are trying to ' \
             ' solve based on the ratings you gave to the three questions. Please write a minimum of 1-2 sentences' \
             ' and a maximum of 500 words (approximately 1 page).',
      content: '',
      instruction: 'Please fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'For each feature (user story) that is being proposed for this sprint (minimum of 2-3):<br />'\
              '<ul>'\
                '<li>Is the user role (e.g. public, member, admin) well specified?</li>'\
                '<li>Is the desired outcome (user goal)&nbsp;clear?</li>'\
                '<li>(Optional) Is the benefit clear?</li>'\
              '</ul>',
      content: '["Strongly Disagree",' \
               '"Disagree",' \
               '"Neutral",' \
               '"Agree",' \
               '"Strongly Agree"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please give written feedback to explain your rating for whether the features'\
              ' (user stories) have been clearly specified.&nbsp;Please write a minimum of 1-2 sentences and a'\
              ' maximum of 500 words (approximately 1 page).',
      content: '',
      instruction: 'Please fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'In the agile software development methodology, it is useful to be able to'\
              ' demonstrate a working product at the end of the iteration. Would the set of features that has'\
              ' been selected for implementation give a minimum viable product (if not, the features are probably'\
              ' less important)? If the selected features are successfully implemented, there will'\
              ' be a minimum viable product to demonstrate by the end of this sprint.',
      content: '["Strongly Disagree",' \
               '"Disagree",' \
               '"Neutral",' \
               '"Agree",' \
               '"Strongly Agree"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please explain your rating on whether the set of features selected for implementation'\
              ' is appropriate. Can the system be demonstrated after the feature set is completed in this'\
              ' sprint? Please write a minimum of 1-2 sentences and a maximum of 500 words (approximately 1 page)',
      content: '',
      instruction: 'Please fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'The written project README should clearly explain the purpose of the project'\
              ' and each of the feature to be implemented in the next sprint, and have a draft plan for the'\
              ' remaining sprints.',
      content: '["I still have no idea what the project is supposed to do.",' \
               '"I have a reasonable idea of what the project does but not of the features.",' \
               '"I have a reasonable idea of what the project does and a rough idea of the features.",' \
               '"I have a good idea of what the project does and a reasonable idea of the features to be implemented.",' \
               '"Excellent!"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'The log (appended at the end of the README) should clearly document how much'\
              ' time the team (and its individual students, where applicable) have spent on their Orbital work'\
              ' so far.',
      content: '["I still have no idea of how much time the team members have invested in their project.",' \
               '"I have a reasonable idea of how much time the team members have invested in their project and some vague notion of what they have spent it on.",' \
               '"I have a reasonable idea of both how much time the team members have invested in their project and what they have spent it on.",' \
               '"I have a good idea of how much time the team members have invested in their project and what they have spent it on.",' \
               '"Excellent! I learned from this group\'s log and what I can do in my own project for logging."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please point out any problems with the README and log and give suggestions on how'\
              ' they can be improved. Please write a minimum of 1-2 sentences and a maximum of 500 words'\
              ' (approximately 1 page).',
      content: '',
      instruction: 'Please fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'If there is any critical feedback that you do not want associated with your team, but feel would'\
              ' be helpful to the team to know, please provide it here. Your adviser will cut this section'\
              ' out of the original post and post it separately, under his/her name.',
      content: '',
      instruction: 'Optional. (Maximum 500 words - approximately 1 page)',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: false
    )
    question.save

    question = Question.new(
      title: 'Please give your overall rating for the project submission this iteration. This will be used'\
              ' to help us eventually decide whether the team passes and what level of achievement is obtained.'\
              ' This section <em>will only</em> be viewed by the advisors and not by the target group.',
      content: '["1 of 4 stars. Likely to fail Orbital",' \
               '"2 of 4 stars. Sufficient to pass the beginner level (Vostok), maybe good enough for intermediate level (Gemini)",' \
               '"3 of 4 stars. Definitely intermediate level (Gemini). Maybe good enough for advanced level (Apollo 11)",' \
               '"4 of 4 stars. Definitely good enough for advanced level (Apollo 11).",' \
               '"5. Wow! (Bonus point)"]',
      instruction: 'This section is for the adviser\'s and faciltator\'s reference only.',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: false
    )
    question.save
  end

  def down
    survey_template = SurveyTemplate.find_by(milestone_id: 1, survey_type: 1)
    survey_template.questions.each(&:destroy)
  end
end
