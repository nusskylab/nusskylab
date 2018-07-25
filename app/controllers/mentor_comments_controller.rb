# MentorCommentController: manage actions related to mentor comments
#   new:    view to create a mentor comments
#   create: create a mentor comments
#   edit:   view to edit a mentor comments
#   update: update a mentor comments
class MentorCommentsController < ApplicationController
    def new
      mentor = Mentor.find(params[:mentor_id]) || (record_not_found && return)
      !authenticate_user(true, false, [mentor.user]) && return
      @page_title = t('.page_title')
      @mentor_comment = MentorComment.new
      teams = []
      mentor.teams.each do |team|
        teams.append(team)
      end
      milestone = Milestone.find_by(name: 'Milestone 3', cohort: teams[0].cohort)
      feedback_template = SurveyTemplate.find_by(
        milestone_id: milestone.id,
        survey_type: SurveyTemplate.survey_types[:survey_type_mentor_comments]
      )
      render locals: {
        teams: teams,
        feedback_template: feedback_template
      }
    end
  
    def create
      mentor = Mentor.find(params[:mentor_id]) || (record_not_found && return)
      !authenticate_user(true, false, [mentor.user]) && return
      if create_or_update_feedback_and_responses
        redirect_to home_path, flash: {
          success: t('.success_message')
        }
      else
        redirect_to home_path, flash: {
          danger: t('.failure_message',
                    error_message: @feedback.errors.full_messages.join(', '))
        }
      end
    end
  
    def edit
      mentor = Mentor.find(params[:mentor_id]) || (record_not_found && return)
      !authenticate_user(true, false, [mentor.user]) && return
      @page_title = t('.page_title')
      @mentor_comment = MentorComment.find(params[:id])
      teams = []
      mentor.teams.each do |team|
        teams.append(team.team)
      end
      milestone = Milestone.find_by(name: 'Milestone 3', cohort: team.cohort)
      feedback_template = SurveyTemplate.find_by(
        milestone_id: milestone.id,
        survey_type: SurveyTemplate.survey_types[:survey_type_mentor_comments]
      )
      render locals: {
        teams: teams,
        feedback_template: feedback_template
      }
    end
  
    def update
      mentor = Mentor.find(params[:mentor_id]) || (record_not_found && return)
      !authenticate_user(true, false, [mentor.user]) && return
      @mentor_comment = MentorComment.find(params[:id])
      if create_or_update_feedback_and_responses(@mentor_commentdback)
        redirect_to home_path, flash: {
          success: t('.success_message')
        }
      else
        redirect_to home_path, flash: {
          danger: t('.failure_message',
                    error_message: @mentor_comment.errors.full_messages.join(', '))
        }
      end
    end
  
    private
  
    def mentor_comment_params
      mentor_comment_ps = params.require(:mentor_comment).permit!
      mentor_comment_ps[:mentor_id] = params[:mentor_id]
      mentor_comment_ps = {} if mentor_comment_ps[:edit] == 'on'
      mentor_comment_ps.except!(:feedback_to_team)
      mentor_comment_ps
    end
  
    def questions_params
      params.require(:questions).permit!
    end
  
    def create_or_update_feedback_and_responses(mentor_comment = nil)
      if mentor_comment.nil?
        @mentor_comment = MentorComment.new(mentor_comment_params)
        @mentor_comment_template = SurveyTemplate.find_by(survey_type: SurveyTemplate.survey_types[:survey_type_mentor_comments])
        @mentor_comment.survey_template_id = @mentor_comment_template.id
      else
        mentor_comment.update(mentor_comment_params)
        @mentor_comment = mentor_comment
      end
      @mentor_comment.response_content = questions_params.to_json
      @mentor_comment.save ? @mentor_comment : nil
    end
  end
  