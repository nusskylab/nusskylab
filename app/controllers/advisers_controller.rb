class AdvisersController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  def index
    @advisers = Adviser.all
  end

  def new
    @adviser = Adviser.new
  end

  def create
    @adviser = create_or_update_adviser
    redirect_to advisers_path
  end

  def show
    @adviser = Adviser.find(params[:id])
    milestones, teams_submissions, own_evaluations = get_data_for_adviser
    render locals: {
             milestones: milestones,
             teams_submissions: teams_submissions,
             own_evaluations: own_evaluations
           }
  end

  def edit
    @adviser = Adviser.find(params[:id])
  end

  def update
    @adviser = create_or_update_adviser
    redirect_to @adviser
  end

  def destroy
    @adviser = Adviser.find(params[:id])
    @adviser.destroy
    redirect_to advisers_path
  end

  private
  def create_or_update_adviser
    uid = NUS_OPEN_ID_PREFIX + params[:nus_id]
    provider = NUS_OPEN_ID_PROVIDER
    email = params[:user_email]
    user_name = params[:user_name]
    user = User.create_or_update_by_provider_and_uid(uid: uid,
                                                     provider: provider,
                                                     email: email,
                                                     user_name: user_name)
    adviser = Adviser.create_or_update_by_user_id(user_id: user.id)
    return adviser
  end

  def get_data_for_adviser
    milestones = Milestone.all
    teams_submissions = {}
    own_evaluations = {}
    milestones.each do |milestone|
      teams_submissions[milestone.id] = {}
      @adviser.teams.each do |team|
        teams_submissions[milestone.id][team.id] = Submission.find_by(milestone_id: milestone.id,
                                                                      team_id: team.id)
      end
    end
    return milestones, teams_submissions, own_evaluations
  end
end
