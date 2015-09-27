class AdvisersController < ApplicationController
  def index
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    @advisers = Adviser.all
    respond_to do |format|
      format.html {render}
      format.csv {send_data Adviser.to_csv}
    end
  end

  def new
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    @adviser = Adviser.new
    render locals: {users: User.all}
  end

  def create
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    user = User.find(params[:adviser][:user_id])
    @adviser = Adviser.new(user_id: user.id)
    if @adviser.save
      redirect_to advisers_path, flash: {success: t('.success_message', user_name: user.user_name)}
    else
      redirect_to new_adviser_path, flash: {danger: t('.failure_message',
                                            error_messages: @adviser.errors.full_messages.join(' '))}
    end
  end

  def show
    @adviser = Adviser.find(params[:id])
    not authenticate_user(true, false, [@adviser.user]) and return
    @page_title = t('.page_title', user_name: @adviser.user.user_name)
    milestones, teams_submissions, own_evaluations = get_data_for_adviser
    render locals: {
             milestones: milestones,
             teams_submissions: teams_submissions,
             own_evaluations: own_evaluations
           }
  end

  def destroy
    not authenticate_user(true, true) and return
    @adviser = Adviser.find(params[:id])
    if @adviser.destroy
      redirect_to advisers_path, flash: {success: t('.success_message', user_name: @adviser.user.user_name)}
    else
      redirect_to advisers_path, flash: {danger: t('.failure_message',
                                         error_messages: @adviser.errors.full_messages.join(' '))}
    end
  end

  private
  def get_data_for_adviser
    milestones = Milestone.all
    teams_submissions = {}
    own_evaluations = {}
    milestones.each do |milestone|
      teams_submissions[milestone.id] = {}
      own_evaluations[milestone.id] = {}
      @adviser.teams.each do |team|
        team_sub = Submission.find_by(milestone_id: milestone.id,
                                      team_id: team.id)
        teams_submissions[milestone.id][team.id] = team_sub
        if team_sub
          own_evaluations[milestone.id][team.id] =
            PeerEvaluation.find_by(submission_id: team_sub.id,
                                   adviser_id: @adviser.id)
        end
      end
    end
    return milestones, teams_submissions, own_evaluations
  end
end
