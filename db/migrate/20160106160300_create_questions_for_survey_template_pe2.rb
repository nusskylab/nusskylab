class CreateQuestionsForSurveyTemplatePe2 < ActiveRecord::Migration
  def up
    survey_template = SurveyTemplate.find_by(milestone_id: 2, survey_type: 1)

    question = Question.new(
      title: 'For each of the user stories already implemented'\
              '<ul>'\
                '<li>Describe whether you would accept the feature as an'\
                ' acceptance tester (does it adequately do what was specified?).</li>'\
                '<li>If it is not adequate, describe what should be done it'\
                ' make it acceptable by the end of the project.</li>'\
              '</ul>'\
              '<p>Please write a minimum of 1-2 sentences.</p>',
      content: '<p><span style="color: #999999;"><em>(E.g. , &lt;below is just'\
                ' a template&gt; </em></span></p>'\
                '<ul>'\
                  '<li><span style="color: #999999;"><em>Feature 1 -'\
                  ' Open ID Logins - seems to work.&nbsp; Tested it with'\
                  ' a sample login.&nbsp; Accepted.)</em></span></li>'\
                  '<li><span style="color: #999999;"><em>Feature 2 -'\
                  ' Add an item - doesn\'t seem to work with rich text.;'\
                  ' Would be much better if I could format it with rich text.;'\
                  ' Marginally accepted.<br /></em></span></li>'\
                  '<li><span style="color: #999999;"><em>Feature 3 -'\
                  ' Delete an item - button is there but when pressed gives'\
                  ' inconsistent results -- numbering of items and the labels'\
                  ' for items seem to be all messed up afterwards.&nbsp;'\
                  ' Clearly buggy.&nbsp; Not accepted.)</em></span></li>'\
                '</ul>',
      instruction: 'Please use a short descriptive phrase for each user story and then answer each question',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'For each feature (user story) that is being proposed for this sprint (minimum of 2-3):'\
              '<ul>'\
                '<li>Is the user role (e.g. public, member, admin) well specified?</li>'\
                '<li>Is the desired outcome (user goal) clear?</li>'\
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
      title: 'Please give written feedback to explain your rating for whether the'\
              ' features (user stories) have been clearly specified for this final'\
              ' sprint.&nbsp; At the end, will you accept that the team has'\
              ' accomplished the necessary requirements for their aimed level of'\
              ' achievement (with respect to project implementation and depth)?<br />'\
              ' Please write a minimum of 1-2 sentences and a maximum of 500 words.',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'How usable is the proposed / implemented user interface for experts'\
              '(efficiency in doing common tasks that an expert user has to do)?',
      content: '["Poor. The expert has to repeat unnecessary steps for each use.",' \
               '"Adequate. An expert would be comfortable using this.",' \
               '"Excellent. Long time user would enjoy using this."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'How usable is the proposed / implemented user interface for novices'\
              ' (ability to reach a reasonable level of performance rapidly)?',
      content: '["Hard to figure out for new users.",' \
               '"Adequate for most novices.",' \
               '"Excellent. Clear and easy to understand for novices."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Is it easy for a user to remember how to use the system?',
      content: '["Poor. The design of the workflow should be improved.",' \
               '"Adequate. An average user should have no problem using'\
               ' the system and remembering how to use it.",' \
               '"Excellent. The system is easy to use and remember."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Does the <strong>current</strong> project implementation have adequate'\
              ' functionality to satisfy an average user from a utilitarian perspective?'\
              ' Does it contain adequate error messages and error prevention mechanisms'\
              ' and documentation to help the user achieve the user stories\' objective?</p>'\
              ' <p><span style="color: #999999;"><em>(It is important to remember that'\
              ' when designing services that the end user may not be you and as such,'\
              ' what you expect users to do and know will almost always be different'\
              ' than what you think. &nbsp;In reality, testing and development'\
              ' often are scheduled as part of each sprint, so that teams get'\
              ' constant feedback during the development process.)</em></span></p>',
      content: '["Insufficient. A user may get lost and be unable to figure out how to use the functions.",' \
               '"Adequate. An average user would be able to figure out how to use the functions.",' \
               '"Excellent. Almost all users will be able to figure out how to use the functions."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?'\
              ' Did they use Expert / Self evaluation?',
      content: '["Yes",' \
               '"No"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?'\
              ' Did they use Cognitive Walk through / Heuristic Evaluation / User stories?',
      content: '["Yes",' \
               '"No"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?'\
              ' Did they use Simulated User Focus Group?',
      content: '["Yes",' \
               '"No"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?'\
              ' Did they use Actual User Focus Group / Interview?',
      content: '["Yes",' \
               '"No"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?'\
              ' Did they use Usability Testing with Potential Users on Low-Fidelity artefacts (e.g., Powerpoint mockup)?',
      content: '["Yes",' \
               '"No"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?'\
              ' Did they use Survey of Potential Users?',
      content: '["Yes",' \
               '"No"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?'\
              ' Did they use Usability Testing with Potential Users with High-Fidelity artefacts'\
              ' (e.g., working prototype, App Engine prototype)?',
      content: '["Yes",' \
               '"No"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Describe how the team might work towards better and more comprehensive'\
              ' testing.; If you know of methods that the team might employ to find'\
              ' suitable evaluation subjects, please share this with them here as well.'\
              ' <br />Please write a minimum of 1-2 sentences and a maximum of 500 words.',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'The written project README clearly explain the purpose of the project'\
               ' and each of the feature to be implemented in the next sprint, and have'\
               ' a draft plan for the remaining sprints.',
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
      title: 'The 3-minute video demonstration (referenced in the README) should'\
              ' clearly showcase the project\'s purpose, scope and features implemented so far.'\
              ' It should assist you as an evaluating team in the peer evaluation process.',
      content: '["I couldn\'t view the video, or there were too many problems with the submitted video.",' \
               '"The video makes minimal effort to document their project\'s work'\
                ' and features, and/or just repeats information from the README and log.",' \
               '"The video is mostly complete.&nbsp; I have some sense of the purpose,'\
                ' scope and features of the project, but some aspects are not clear.",' \
               '"The video was complete and I have a good sense of the goals, scope and features of the project.",' \
               '"Excellent! The video was as complete as could be given the 3-minute time limit.'\
                ' It was well-produced and I also learned from it how to improve my own work."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'The log (appended at the end of the README) should clearly document'\
              ' how much time the team (and its individual students, where applicable)'\
              ' have spent on their Orbital work so far.',
      content: '["I still have no idea of how much time the team members have invested in their project.",' \
               '"I have a reasonable idea of how much time the team members have invested'\
                ' in their project and some vague notion of what they have spent it on.",' \
               '"I have a reasonable idea of both how much time the team members'\
                ' have invested in their project and what they have spent it on.",' \
               '"I have a good idea of how much time the team members have invested'\
                ' in their project and what they have spent it on.",' \
               '"Excellent! I learned from this group\'s log and what I can do'\
                ' in my own project for logging."]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please point out any problems with the README, video and log and'\
              ' give suggestions on how they can be improved. Please write a'\
              ' minimum of 1-2 sentences and a maximum of 500 words.',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'If there is any critical feedback that you do not want associated'\
              'with your team, but feel would be helpful to the team to know,'\
              'please provide it here. This is anonymous.',
      content: '',
      instruction: 'Optional',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: false
    )
    question.save

    question = Question.new(
      title: 'Please give your overall rating for the project submission this'\
              ' iteration. This will be used to help us eventually decide whether'\
              ' the team passes and what level of achievement is obtained.'\
              ' This section <em>will only</em> be viewed by the advisors and not'\
              ' by the target group.',
      content: '["1 of 4 stars. Likely to fail Orbital",' \
               '"2 of 4 stars. Sufficient to pass the beginner level (Vostok),'\
                 ' maybe good enough for intermediate level (Gemini)",' \
               '"3 of 4 stars. Definitely intermediate level (Gemini). Maybe'\
                ' good enough for advanced level (Apollo 11)",' \
               '"4 of 4 stars. Definitely good enough for advanced level (Apollo 11).",' \
               '"5. Wow! (Bonus point)"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: false
    )
    question.save
  end

  def down
    survey_template = SurveyTemplate.find_by(milestone_id: 2, survey_type: 1)
    survey_template.questions.each(&:destroy)
  end
end
