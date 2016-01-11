class CreateQuestionsForSurveyTemplatePe3 < ActiveRecord::Migration
  def up
    survey_template = SurveyTemplate.find_by(milestone_id: 3, survey_type: 1)

    question = Question.new(
      title: 'For each of the user stories already implemented
            <ul>
              <li>Describe whether you would accept the feature as an acceptance
                tester (does it adequately do what was specified?).</li>
              <li>If it is not adequate, describe what should be done it make it
                acceptable in future work (beyond Evaluation 3).</li>
            </ul>
            <p>Please write a minimum of 1-2 sentences.</p>',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Is the project ready for use by the target audience? If not, what
             are the minimal additional features required to get it ready?',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Suggest 1-3 additional features for future releases of the project,
              in order of importance (These may be repeated from the target
              group\'s own assessment, if you agree with their assessment).',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Does the project go beyond adequacy and try to provide a pleasant
        user experience (UX)? This can be in terms of how functionality was
        achieved to make the project more pleasant to interact with (e.g.,
        artwork, interaction design). Please rate this on a scale of 0 (none),
        1 (little effort) to 5 (many obvious good design choices and
        implementation).',
      content: '[\"0. Not adequate.\",' \
               '\"1. Neutral. Suitable for projects where interaction is not a
               part (i.e., user is not an end user).\",' \
               '\"2. Marginally agree. UX was definitely considered, but not
                really customized in any way beyond standard practices (e.g.,
                application of Bootstrap).\",' \
               '\"3. Agree. The design of key parts of the UX is solidly
                implemented.\",' \
               '\"4. Strongly agree. The design of all functionality (both
                commonly used and occasional used functions) is considered
                well.\",'\
               '\"5. Excellent. I enjoy the project enough to recommend it to
                 others.\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please write 1-2 sentences to justify any non-0 and non-1 score,
       by recalling a function and how it was achieved in a pleasurable way) in
       the previous question on beyond adequacy.',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?
              Did they use Expert / Self evaluation?',
      content: '[\"Yes\",' \
               '\"No\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?
              Did they use Cognitive Walk through / Heuristic Evaluation / User stories?',
      content: '[\"Yes\",' \
               '\"No\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?
              Did they use Simulated User Focus Group?',
      content: '[\"Yes\",' \
               '\"No\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?
              Did they use Actual User Focus Group / Interview?',
      content: '[\"Yes\",' \
               '\"No\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?
              Did they use Usability Testing with Potential Users on Low-Fidelity artefacts (e.g., Powerpoint mockup)?',
      content: '[\"Yes\",' \
               '\"No\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?
              Did they use Survey of Potential Users?',
      content: '[\"Yes\",' \
               '\"No\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'What types of methods did the team use to evaluate the suitability of their solution (if any)?
              Did they use Usability Testing with Potential Users with High-Fidelity artefacts
              (e.g., working prototype, App Engine prototype)?',
      content: '[\"Yes\",' \
               '\"No\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please rate the average quality of the testing from 0 (no testing,
       1 (little effort) to 5 (a lot of effort). You might evaluate the testing
       in terms of it being able to 1) influence their project outcome, 2)
       convince users or evaluators of the design or implementation of their
       project.',
      content: '[\"0. No testing done (suitable for Vostok).\",' \
               '\"1. Little effort. Self-testing or thought walkthroughs only
                -- but not convincingly done.\",' \
               '\"2. Getting there. Almost convincing at least on some key
                aspects (suitable for Project Gemini).\",' \
               '\"3. Adequate. Evaluation is useful and convincing for at least
                some aspects of the system.\",' \
               '\"4. Very good. Evaluation definitely shows the quality of the
                project, in design, implementation and/or outcome.\",'\
               '\"5. Excellent. Multi-pronged evaluations done, convincing and
                affected project outcome.\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Describe how the team might work towards better and more
       comprehensive testing.&nbsp; If you know of methods that the team might
       employ to find suitable evaluation subjects, please share this with them
       here as well. <br />Please write a minimum of 1-2 sentences and a maximum
       of 500 words',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Does the project implementation have adequate functionality to
       satisfy an average user from a utilitarian perspective? Does it contain
       adequate error messages and error prevention mechanisms and documentation
       to help the user achieve the user stories\' objective?',
      content: '[\"Insufficient. A user may get lost and be unable to figure out
                how to use the functions.\",' \
               '\"Adequate. An average user would be able to figure out how to
                use the functions.\",'\
               '\"Excellent. Almost all users will be able to figure out how to
                use the functions.\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'The 5- to 7-minute video (referenced in the README) should clearly
       showcase the project\'s purpose, scope and features implemented so far.
       It should assist you as an evaluating team in the peer evaluation
       process. The video is the culmination of the project\'s overview. Peers
       use the video as a means of understanding the key parts of the project
       before consulting the final README and log for details. The video may
       also be shown at the Splashdown session.',
      content: '[\"I couldn\'t view the video, or there were too many problems
                with the submitted video.<br />(0 out of 3)\",' \
               '\"The video makes minimal effort to document their project\'s
                work and features, and/or just repeats information from the
                README and log.<br />(1 out of 3)\",' \
               '\"The video is mostly complete.&nbsp; I have some sense of the
                purpose, scope and features of the project, but some aspects are
                not clear.<br />(2 out of 3)\",' \
               '\"The video was complete and I have a good sense of the goals,
                scope and features of the project.<br /> (3 out of 3)\",' \
               '\"Excellent! The video was as complete as could be given the
                time limit. It was well-produced and I also learned from it how
                to improve my own work.&nbsp; <br />(bonus point)\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'The README contains more specific and technical details on the
       project executed including the specification of the features, the user
       stories, and the list of technologies learned and/or applied in the
       project.',
      content: '[\"Strongly Disagree\",' \
               '\"Disagree\",' \
               '\"Neutral\",' \
               '\"Agree\",' \
               '\"Strongly Agree\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'The log (appended at the end of the README) should clearly
       document how much time the team (and its individual students, where
       applicable) have spent on their Orbital work so far.',
      content: '[\"I still have no idea of how much time the team members have
                invested in their project.\",' \
               '\"I have a reasonable idea of how much time the team members
                have invested in their project and some vague notion of what
                they have spent it on.\",' \
               '\"I have a reasonable idea of both how much time the team
                members have invested in their project and what they have spent
                it on.\",' \
               '\"I have a good idea of how much time the team members have
                invested in their project and what they have spent it on.\",' \
               '\"Excellent! I learned from this group\'s log and what I can do
                in my own project for logging.\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please point out any problems with the README, video and log and
       give suggestions on how they can be improved. Please write a minimum of
       1-2 sentences and a maximum of 500 words',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'If there is any critical feedback that you do not want associated
       with your team, but feel would be helpful to the team to know, please
       provide it here.&nbsp; Your adviser will cut this section out of the
       original post and post it separately, under his/her name.',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please give your overall rating for the project submission this
       iteration. This will be used to help us eventually decide whether the
       team passes and what level of achievement is obtained. This section <em>
       will only</em> be viewed by the advisors and not by the target group.',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please give your overall rating for the project submission this
              iteration. This will be used to help us eventually decide whether
              the team passes and what level of achievement is obtained.
              This section <em>will only</em> be viewed by the advisors and not
              by the target group.',
      content: '[\"1 of 4 stars. Likely to fail Orbital\",' \
               '\"2 of 4 stars. Sufficient to pass the beginner level (Vostok),
                  maybe good enough for intermediate level (Gemini)\",' \
               '\"3 of 4 stars. Definitely intermediate level (Gemini). Maybe
                  good enough for advanced level (Apollo 11)\",' \
               '\"4 of 4 stars. Definitely good enough for advanced level (Apollo 11).\",' \
               '\"5. Wow! (Bonus point)\"]',
      instruction: 'Please choose one option',
      question_type: 2,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save

    question = Question.new(
      title: 'Please give your reasons if your rating is not consistent with the
       group\'s own evaluation of their achievements.',
      content: '',
      instruction: 'Fill in the blank',
      question_type: 0,
      survey_template_id: survey_template.id,
      is_public: true
    )
    question.save
  end

  def down
    survey_template = SurveyTemplate.find_by(milestone_id: 3, survey_type: 1)
    survey_template.questions.each(&:destroy)
  end
end
