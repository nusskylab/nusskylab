module ApplicationHelper
  FORM_QUESTION_ID_PREFIX = 'questions['
  FROM_QUESTION_ID_SUFFIX = ']'
  NUS_OPEN_ID_PATH = 'https://openid.nus.edu.sg/auth'

  def javascript(*files)
    content_for(:js_head) { javascript_include_tag(*files) }
  end

  def omniauth_authorize_path(provider)
    if provider.to_s == 'open_id'
      NUS_OPEN_ID_PATH
    end
  end

  def get_question_name(question)
    return FORM_QUESTION_ID_PREFIX + question.id.to_s + FROM_QUESTION_ID_SUFFIX
  end

  def get_current_cohort
    Time.now.year
  end

  def survey_template_type_to_human(survey_template_type)
    survey_template_type.split('_')[2..-1].map(&:capitalize!).join(' ')
  end

  def get_portal_open_date 
    open_date = ApplicationDeadline.find_by(name: 'portal open date').submission_deadline
  end
end
