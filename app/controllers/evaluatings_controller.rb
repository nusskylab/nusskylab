class EvaluatingsController < ApplicationController
  def index
    display_all_evaluatings_strategy = lambda {
      if not Adviser.adviser?(current_user.id).nil?
        return true
      end
    }
    not check_access(true, false, display_all_evaluatings_strategy) and return
    adviser = Adviser.adviser?(current_user.id)
    if Admin.admin?(current_user.id)
      @evaluatings = Evaluating.all
    elsif adviser
      evaluatings = Evaluating.all
      advisers_evaluatings = []
      evaluatings.each do |evaluating|
        if (evaluating.evaluated.adviser_id and
          evaluating.evaluated.adviser_id == adviser.id) and
          (evaluating.evaluator.adviser_id and
          evaluating.evaluator.adviser_id == adviser.id)
          advisers_evaluatings.append(evaluating)
        end
      end
      @evaluatings = advisers_evaluatings
      render
    end
  end

  def new
    create_evaluating_strategy = lambda {
      if not Adviser.adviser?(current_user.id).nil?
        return true
      end
    }
    not check_access(true, false, create_evaluating_strategy) and return
    @evaluating = Evaluating.new
    adviser = Adviser.adviser?(current_user.id)
    if Admin.admin?(current_user.id)
      render locals: {
               teams: Team.all
             }
    elsif adviser
      render locals: {teams: adviser.teams}
    end
  end

  def create
    create_evaluatings_strategy = lambda {
      if not Adviser.adviser?(current_user.id).nil?
        return true
      end
    }
    not check_access(true, false, create_evaluatings_strategy) and return
    if create_evaluation_relationship
      redirect_to evaluatings_path, flash: {success: 'The evaluating relation is successfully created'}
    else
      redirect_to new_evaluating_path, flash: {danger: @evaluating.errors.full_messages.join(', ')}
    end
  end

  def batch_upload
    not check_access(true, true) and return
    @evaluating = Evaluating.new
  end

  def batch_create
    not check_access(true, true) and return
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
    adviser = Adviser.adviser?(current_user.id)
    edit_evaluating_strategy = lambda {
      if not adviser.nil?
        if @evaluating and @evaluating.evaluated.adviser_id == adviser.id and
          @evaluating.evaluator.adviser_id == adviser.id
          return true
        else
          return false
        end
      end
    }
    not check_access(true, false, edit_evaluating_strategy) and return
    if Admin.admin?(current_user.id)
      render locals: {
               teams: Team.all
             }
    elsif adviser
      render locals: {teams: adviser.teams}
    end
  end

  def update
    @evaluating = Evaluating.find(params[:id])
    adviser = Adviser.adviser?(current_user.id)
    update_evaluating_strategy = lambda {
      if not adviser.nil?
        if @evaluating and @evaluating.evaluated.adviser_id == adviser.id and
          @evaluating.evaluator.adviser_id == adviser.id
          return true
        else
          return false
        end
      end
    }
    not check_access(true, false, update_evaluating_strategy) and return
    if update_evaluation_relationship
      redirect_to evaluatings_path, flash: {success: 'The evaluating relation is successfully edited'}
    else
      redirect_to edit_evaluating_path(@evaluating.id), flash: {danger: @evaluating.errors.full_messages.join(', ')}
    end
  end

  def destroy
    @evaluating = Evaluating.find(params[:id])
    adviser = Adviser.adviser?(current_user.id)
    destroy_evaluating_strategy = lambda {
      if not adviser.nil?
        if @evaluating and @evaluating.evaluated.adviser_id == adviser.id and
          @evaluating.evaluator.adviser_id == adviser.id
          return true
        else
          return false
        end
      end
    }
    not check_access(true, false, destroy_evaluating_strategy) and return
    evaluating = Evaluating.find(params[:id])
    if evaluating.destroy
      redirect_to evaluatings_path, flash: {success: 'The evaluating relation is successfully deleted'}
    else
      redirect_to evaluatings_path, flash: {danger: 'The evaluating relation is not successfully deleted'}
    end
  end

  def get_page_title
    @page_title = @page_title || 'Evaluatings | Orbital'
    super
  end

  private
    def get_evaluating_params
      evaluating_params = params.require(:evaluating).permit(:evaluated_id, :evaluator_id)
    end

    # TODO: refactor the following two methods for common part
    def create_evaluation_relationship
      @evaluating = Evaluating.new(get_evaluating_params)
      adviser = Adviser.adviser?(current_user.id)
      if not Admin.admin?(current_user.id).nil?
        @evaluating.save ? @evaluating : nil
      elsif not adviser.nil?
        if @evaluating.evaluated and @evaluating.evaluated.adviser_id == adviser.id and
          @evaluating.evaluator and @evaluating.evaluator.adviser_id == adviser.id
          @evaluating.save ? @evaluating : nil
        else
          nil
        end
      end
    end

    def update_evaluation_relationship
      adviser = Adviser.adviser?(current_user.id)
      if not Admin.admin?(current_user.id).nil?
        (@evaluating and @evaluating.update(get_evaluating_params)) ? @evaluating : nil
      elsif not adviser.nil?
        if @evaluating.evaluated and @evaluating.evaluated.adviser_id == adviser.id and
          @evaluating.evaluator and @evaluating.evaluator.adviser_id == adviser.id
          @evaluating.save ? @evaluating : nil
        else
          nil
        end
      end
    end

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

    def process_team_name_from_row(raw_name)
      if raw_name.to_i != 0
        return 'Team ' + raw_name
      else
        return raw_name
      end
    end

    def create_evaluating_for_two_teams(evaluator, evaluated)
      if (not evaluated.nil?) and (not evaluator.nil?)
        evaluating = Evaluating.new(evaluator_id: evaluator.id, evaluated_id: evaluated.id)
        evaluating.save
      end
    end
end
