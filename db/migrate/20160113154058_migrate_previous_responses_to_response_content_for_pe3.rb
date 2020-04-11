class MigratePreviousResponsesToResponseContentForPe3 < ActiveRecord::Migration
  def up
    submissions = Submission.where(milestone_id: 3)
    survey_template = SurveyTemplate.find_by(milestone_id: 3, survey_type: 1)
    submissions.each do |submission|
      peer_evaluations = PeerEvaluation.where(submission_id: submission.id)
      peer_evaluations.each do |peer_evaluation|
        begin
          pub = JSON.parse(peer_evaluation.public_content)
          pri = JSON.parse(peer_evaluation.private_content)
          response_content = {}
          question_idx = 0
          pub.keys.sort.each do |pub_key|
            q = survey_template.questions[question_idx]
            if q.question_type == 'question_type_multiple_choice'
              response_content[q.id.to_s] = (pub[pub_key].to_i - 1).to_s
            else
              response_content[q.id.to_s] = pub[pub_key]
            end
            question_idx = question_idx + 1
          end
          pri.keys.sort.each do |pri_key|
            q = survey_template.questions[question_idx]
            if q.question_type == 'question_type_multiple_choice'
              response_content[q.id.to_s] = (pri[pri_key].to_i - 1).to_s
            else
              response_content[q.id.to_s] = pri[pri_key]
            end
            question_idx = question_idx + 1
          end
          peer_evaluation.response_content = response_content.to_json
        rescue
          peer_evaluation.response_content = '{}'
        end
        peer_evaluation.save
      end
    end
  end

  def down
    #
  end
end
