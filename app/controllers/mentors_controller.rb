class MentorsController < ApplicationController

  def index
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    @mentors = Mentor.all
  end

  def new
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    @mentor = Mentor.new
    render locals: {
             users: User.all
           }
  end

  def create
    not authenticate_user(true, true) and return
    user = User.find(params[:mentor][:user_id])
    @mentor = Mentor.new(user_id: user.id)
    if @mentor.save
      redirect_to mentors_path, flash: {success: t('.success_message', user_name: user.user_name)}
    else
      redirect_to new_mentor_path, flash: {danger: t('.failure_message',
                                           error_messages: @mentor.errors.full_messages.join(' '))}
    end
  end

  def show
    @mentor = Mentor.find(params[:id])
    not authenticate_user(true, false, [@mentor.user]) and return
    @page_title = t('.page_title', user_name: @mentor.user.user_name)
    milestones, teams_submissions, own_evaluations = get_data_for_mentor
    render locals: {
             milestones: milestones,
             teams_submissions: teams_submissions,
             own_evaluations: own_evaluations
           }
  end

  def destroy
    not authenticate_user(true, true) and return
    @mentor = Mentor.find(params[:id])
    if @mentor.destroy
      redirect_to mentors_path, flash: {success: t('.success_message', user_name: @mentor.user.user_name)}
    else
      redirect_to mentors_path, flash: {danger: t('.failure_message',
                                        error_messages: @mentor.errors.full_messages.join(' '))}
    end
  end

  private
  def get_data_for_mentor
    milestones = Milestone.all
    teams_submissions = {}
    own_evaluations = {}
    milestones.each do |milestone|
      teams_submissions[milestone.id] = {}
      @mentor.teams.each do |team|
        teams_submissions[milestone.id][team.id] = Submission.find_by(milestone_id: milestone.id,
                                                                      team_id: team.id)
      end
    end
    return milestones, teams_submissions, own_evaluations
  end
end
