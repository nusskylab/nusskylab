class AddSurveyTemplateResponsesToPeerEvaluations < ActiveRecord::Migration
  def up
    add_column :peer_evaluations, :response_content, :json
  end

  def down
    remove_column :peer_evaluations, :response_content, :json
  end
end
