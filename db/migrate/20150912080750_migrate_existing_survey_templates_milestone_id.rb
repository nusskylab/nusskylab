class MigrateExistingSurveyTemplatesMilestoneId < ActiveRecord::Migration
  def change
    milestone = Milestone.order(:peer_evaluation_deadline).last
    SurveyTemplate.all.each do |st|
      st.milestone = milestone
      st.save
    end
  end
end
