class PeerEvaluationsController < ApplicationController
  layout 'general_layout'

  def index
    not check_access(true, false) and return
    if params[:team_id]
      @peer_evaluations = PeerEvaluation.where(team_id: params[:team_id])
    else
      @peer_evaluations = PeerEvaluation.where(adviser_id: params[:adviser_id])
    end
  end

  def new
    not check_access(true, false) and return
    @peer_evaluation = PeerEvaluation.new
    render_template('new') and return
  end

  def create
    not check_access(true, false) and return
    create_peer_evaluation
    redirect_back_user
  end

  def show
    not check_access(true, false) and return
    @peer_evaluation = PeerEvaluation.find(params[:id])
  end

  def edit
    not check_access(true, false) and return
    @peer_evaluation = PeerEvaluation.find(params[:id])
    render_template('edit') and return
  end

  def update
    not check_access(true, false) and return
    update_peer_evaluation
    redirect_back_user
  end

  def destroy
    not check_access(true, false) and return
    @peer_evaluation = PeerEvaluation.find(params[:id])
    @peer_evaluation.destroy
    redirect_to team_peer_evaluations_path(params[:team_id])
  end

  def get_home_link
    if (params[:team_id])
      team = Team.find(params[:team_id])
      return team ? team_path(team) : '/'
    else
      adviser = Adviser.find(params[:adviser_id])
      return adviser ? adviser_path(adviser) : '/'
    end
  end

  private
    def create_peer_evaluation
      @peer_evaluation = PeerEvaluation.new(get_evaluation_params)
      @peer_evaluation.save ? @peer_evaluation : nil
    end

    def update_peer_evaluation
      @peer_evaluation = PeerEvaluation.find(params[:id])
      eval_params = get_evaluation_params
      eval_params[:submission_id] = @peer_evaluation.submission_id
      @peer_evaluation.update(eval_params) ? @peer_evaluation : nil
    end

    def get_evaluation_params
      eval_params = params.require(:peer_evaluation).permit(:public_content,
                                                            :private_content,
                                                            :submission_id,
                                                            :published)
      if params[:team_id]
        eval_params[:team_id] = params[:team_id]
      elsif params[:adviser_id]
        eval_params[:adviser_id] = params[:adviser_id]
      end
      eval_params
    end

    def get_submissions_for_page
      if params[:team_id]
        get_submissions_for_team
      elsif params[:adviser_id]
        get_submissions_for_adviser
      end
    end

    def get_submissions_for_team
      team = Team.find(params[:team_id])
      evaluateds = team.evaluateds
      submissions = []
      evaluateds.each do |evaluated|
        submissions += evaluated.evaluated.submissions
      end
      submissions
    end

    def get_submissions_for_adviser
      adviser = Adviser.find(params[:adviser_id])
      teams = adviser.teams
      submissions = []
      teams.each do |team|
        submissions += team.submissions
      end
      submissions
    end

    def render_template(template_name)
      render template_name, locals: {
               submissions: get_submissions_for_page
             }
    end

    def redirect_back_user
      if @peer_evaluation.errors.any?
      else
        if @peer_evaluation[:team_id]
          redirect_to team_path(@peer_evaluation[:team_id])
        elsif @peer_evaluation[:adviser_id]
          redirect_to adviser_path(@peer_evaluation[:adviser_id])
        end
      end
    end
end
