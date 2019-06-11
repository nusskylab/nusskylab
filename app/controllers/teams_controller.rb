# TeamsController
class TeamsController < ApplicationController
  def index
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    cohort = params[:cohort] || current_cohort
    @teams = Team.order(:team_name).where(cohort: cohort)
    @page_title = t('.page_title')
    respond_to do |format|
      format.html do
        render locals: {
          all_cohorts: all_cohorts,
          cohort: cohort
        }
      end
      format.csv { send_data Team.to_csv(cohort: cohort) }
    end
  end

  def new
    !authenticate_user(true, true) && return
    @team = Team.new
    cohort = params[:cohort] || current_cohort
    @page_title = t('.page_title')
    render locals: {
      advisers: Adviser.where(cohort: cohort),
      mentors: Mentor.where(cohort: cohort),
      cohort: cohort
    }
  end

  def create
    !authenticate_user(true, true) && return
    @team = Team.new(team_params)
    cohort = @team.cohort || current_cohort
    if @team.save
      redirect_to teams_path(cohort: cohort), flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to new_team_path(cohort: cohort), flash: {
        danger: t('.failure_message',
                  error_message: @team.errors.full_messages.join(', '))
      }
    end
  end

  def show
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(true, true)) && return
    @page_title = t('.page_title', team_name: @team.team_name)
    cohort = @team.cohort || current_cohort
    @teamsMentorMatchings = MentorMatchings.where(:team_id => params[:id]).order(:choice_ranking);
    render locals: data_for_display
  end

  def edit
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(false, false)) && return
    @page_title = t('.page_title', team_name: @team.team_name)
    cohort = @team.cohort || current_cohort
    render locals: {
      advisers: Adviser.where(cohort: cohort),
      mentors: Mentor.where(cohort: cohort)
    }
  end

  def update
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(false, false)) && return
    if @team.update(team_params)
      redirect_to team_path(@team.id), flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to edit_team_path(params[:id]), flash: {
        danger: t('.failure_message',
                  team_name: @team.team_name,
                  error_message: @team.errors.full_messages.join(', '))
      }
    end
  end

  def destroy
    !authenticate_user(true, true) && return
    @team = Team.find(params[:id])
    cohort = @team.cohort || current_cohort
    if @team.destroy
      redirect_to teams_path(cohort: cohort), flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to teams_path(cohort: cohort), flash: {
        danger: t('.failure_message', team_name: @team.team_name)
      }
    end
  end

  def match_mentor
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(true, true)) && return
    cohort = @team.cohort || current_cohort
    @teamsMentorMatchings = MentorMatchings.where(:team_id => params[:id]);
    
    render locals: {
      mentors: Mentor.joins(:user).select('users.*').where(cohort: cohort),
    }
  end

  def match_mentor_success
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(false, false)) && return
    cohort = @team.cohort || current_cohort
    choices = [ params[:team][:choice_1], params[:team][:choice_2], params[:team][:choice_3] ]
    teamsMentorMatchings = MentorMatchings.where(:team_id => params[:id]).ids;

    if ((choices[0] == choices[2]) || (choices[0] == choices[1]) || (choices[1] == choices[2])) 
      redirect_to match_mentor_team_path(), flash: {
        danger: t('.failure_message')
      }
      return
    end
    #See if can edit else create
    if teamsMentorMatchings.any?
      if MentorMatchings.edit_mentor_preferences(@team, choices, cohort, teamsMentorMatchings)
        redirect_to team_path(@team.id), flash: {
          success: t('.success_message')
        }
        return
      else   
        redirect_to match_mentor_team_path(), flash: {
          danger: t('.error_message', 
            error_message: @team.errors.full_messages.join(', ') 
          )
        }
        return  
      end
    elsif MentorMatchings.match_mentor(@team, choices, cohort)
      redirect_to team_path(@team.id), flash: {
        success: t('.success_message')
      }
      return
    else
      redirect_to match_mentor_team_path(), flash: {
        danger: t('.error_message', 
          error_message: @team.errors.full_messages.join(', ') 
        )
      }
      return
    end
  end 

  private
  
  def team_params
    team_ps = params.require(:team).permit(:team_name, :project_level,
                                           :adviser_id, :mentor_id,
                                           :has_dropped, :cohort, :poster_link, :video_link)
    team_ps[:project_level] = Team.get_project_level_from_raw(
      team_ps[:project_level]) if team_ps[:project_level]
    team_ps
  end

  def data_for_display
    milestones = Milestone.order(:id).where(cohort: @team.cohort)
    survey_templates = []
    milestones.each do |milestone|
      survey_templates = survey_templates.concat(milestone.survey_templates)
    end
    basic_data = {
      milestones: milestones,
      survey_templates: survey_templates,
    }
    basic_data.merge(team_related_data)
  end

  def team_related_data
    {
      evaluateds: @team.evaluateds,
      evaluators: @team.evaluators,
      team_submissions: @team.get_own_submissions,
      team_evaluateds_submissions: @team.get_others_submissions,
      team_evaluations: @team.get_own_evaluations_for_others,
      team_evaluators_evaluations: @team.get_evaluations_for_own_team,
      team_feedbacks: @team.get_feedbacks_for_others,
      adviser_feedbacks: @team.get_feedbacks_for_adviser
    }
  end
end
