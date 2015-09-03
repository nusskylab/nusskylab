class EvaluatingsController < ApplicationController
  def index
    not authenticate_user(true, false, Adviser.all.map{|adviser| adviser.user}) and return
    if is_current_user_admin?
      @evaluatings = Evaluating.all
    elsif is_current_user_adviser?
      @evaluatings = Adviser.adviser?(current_user.id).get_advised_teams_evaluatings
    else
      raise ActionController::RoutingError.new(t('application.path_not_found_message'))
    end
    @page_title = t('.page_title')
  end

  def new
    not authenticate_user(true, false, Adviser.all.map{|adviser| adviser.user}) and return
    @evaluating = Evaluating.new
    adviser = Adviser.adviser?(current_user.id)
    if is_current_user_admin?
      teams = Team.all
    elsif adviser
      teams = adviser.teams
    end
    @page_title = t('.page_title')
    render locals: {teams: teams}
  end

  def create
    not authenticate_user(true, false, Adviser.all.map{|adviser| adviser.user}) and return
    @evaluating = Evaluating.new(get_evaluating_params)
    if create_or_update_evaluation_relationship
      redirect_to evaluatings_path,
                  flash: {success: t('.success_message',
                                     entity1_name: @evaluating.evaluator.team_name,
                                     entity2_name: @evaluating.evaluated.team_name)}
    else
      redirect_to new_evaluating_path,
                  flash: {danger: t('.failure_message',
                                    error_messages: @evaluating.errors.full_messages.join(', '))}
    end
  end

  def batch_upload
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
  end

  def batch_create
    not authenticate_user(true, true) and return
    require 'csv'
    evaluatings_csv_file = params[:evaluating][:batch_csv]
    file_rows = CSV.read(evaluatings_csv_file.path, headers: true)
    file_rows.each do |row|
      create_evaluating_from_csv_row(row)
    end
    redirect_to evaluatings_path
  end

  def edit
    @evaluating = Evaluating.find(params[:id])
    not authenticate_user(true, false, get_evaluating_permitted_users) and return
    if is_current_user_admin?
      teams = Team.all
    elsif (adviser = is_current_user_adviser?)
      teams = adviser.teams
    end
    @page_title = t('.page_title')
    render locals: {teams: teams}
  end

  def update
    @evaluating = Evaluating.find(params[:id])
    not authenticate_user(true, false, get_evaluating_permitted_users) and return
    @evaluating.assign_attributes(get_evaluating_params)
    if create_or_update_evaluation_relationship
      redirect_to evaluatings_path,
                  flash: {success: t('.success_message',
                                     entity1_name: @evaluating.evaluator.team_name,
                                     entity2_name: @evaluating.evaluated.team_name)}
    else
      redirect_to edit_evaluating_path(@evaluating),
                  flash: {danger: t('.failure_message',
                                    error_messages: @evaluating.errors.full_messages.join(', '))}
    end
  end

  def destroy
    @evaluating = Evaluating.find(params[:id])
    not authenticate_user(true, false, get_evaluating_permitted_users) and return
    if @evaluating.destroy
      redirect_to evaluatings_path,
                  flash: {success: t('.success_message',
                                     entity1_name: @evaluating.evaluator.team_name,
                                     entity2_name: @evaluating.evaluated.team_name)}
    else
      redirect_to evaluatings_path,
                  flash: {danger: t('.failure_message',
                                    error_messages: @evaluating.errors.full_messages.join(', '))}
    end
  end

  private
  def get_evaluating_params
    params.require(:evaluating).permit(:evaluated_id, :evaluator_id)
  end

  def get_evaluating_permitted_users
    evaluating_users = []
    adviser = Adviser.adviser?(current_user.id) if current_user
    if adviser and @evaluating.evaluated.adviser_id == adviser.id
      evaluating_users.append(adviser.user)
    end
    evaluating_users
  end

  def create_or_update_evaluation_relationship
    adviser = Adviser.adviser?(current_user.id)
    if is_current_user_admin?
      return @evaluating.save ? @evaluating : nil
    elsif not adviser.nil?
      if (@evaluating.evaluated and @evaluating.evaluated.adviser_id == adviser.id) and
        (@evaluating.evaluator and @evaluating.evaluator.adviser_id == adviser.id)
        return @evaluating.save ? @evaluating : nil
      end
    end
    nil
  end

  # TODO: deprecated
  def create_evaluating_from_csv_row(row)
    evaluator_team_name = process_team_name_from_row(row[2])
    evaluated_team_name1 = process_team_name_from_row(row[4])
    evaluated_team_name2 = process_team_name_from_row(row[5])
    evaluated_team_name3 = process_team_name_from_row(row[6])
    evaluator_team = Team.find_by(team_name: evaluator_team_name)
    evaluated_team1 = Team.find_by(team_name: evaluated_team_name1)
    evaluated_team2 = Team.find_by(team_name: evaluated_team_name2)
    evaluated_team3 = Team.find_by(team_name: evaluated_team_name3)
    create_evaluating_for_two_teams(evaluator_team, evaluated_team1)
    create_evaluating_for_two_teams(evaluator_team, evaluated_team2)
    create_evaluating_for_two_teams(evaluator_team, evaluated_team3)
  end

  # TODO: deprecated
  def process_team_name_from_row(raw_name)
    if raw_name.to_i != 0
      return 'Team ' + raw_name
    else
      return raw_name
    end
  end

  # TODO: deprecated
  def create_evaluating_for_two_teams(evaluator, evaluated)
    if (not evaluated.nil?) and (not evaluator.nil?)
      evaluating = Evaluating.new(evaluator_id: evaluator.id, evaluated_id: evaluated.id)
      evaluating.save
    end
  end
end
