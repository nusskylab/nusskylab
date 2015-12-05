# MentorsController: manages mentors related actions
#   index:   list all mentors
#   new:     view to create a new mentor
#   create:  create a new mentor
#   show:    view for a mentor
#   destroy: delete a mentor
class MentorsController < ApplicationController
  def index
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @mentors = Mentor.all
  end

  def new
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @mentor = Mentor.new
    render locals: { users: User.all }
  end

  def create
    !authenticate_user(true, true) && return
    user = User.find(params[:mentor][:user_id])
    @mentor = Mentor.new(user_id: user.id)
    redirect_after_create_action
  end

  def show
    @mentor = Mentor.find(params[:id])
    !authenticate_user(true, false, [@mentor.user]) && return
    @page_title = t('.page_title', user_name: @mentor.user.user_name)
    milestones, teams_submissions, own_evaluations = get_data_for_mentor
    render locals: {
      milestones: milestones,
      teams_submissions: teams_submissions,
      own_evaluations: own_evaluations
    }
  end

  def destroy
    !authenticate_user(true, true) && return
    @mentor = Mentor.find(params[:id])
    if @mentor.destroy
      redirect_to mentors_path, flash: {
        success: t('.success_message', user_name: @mentor.user.user_name)
      }
    else
      redirect_to mentors_path, flash: {
        danger: t('.failure_message',
                  error_messages: @mentor.errors.full_messages.join(' '))
      }
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
        teams_submissions[milestone.id][team.id] = Submission.find_by(
          milestone_id: milestone.id,
          team_id: team.id)
      end
    end
    return milestones, teams_submissions, own_evaluations
  end

  def redirect_after_create_action
    if @mentor.save
      redirect_to mentors_path, flash: {
        success: t('.success_message', user_name: user.user_name)
      }
    else
      redirect_to new_mentor_path, flash: {
        danger: t('.failure_message',
                  error_messages: @mentor.errors.full_messages.join(' '))
      }
    end
  end
end
