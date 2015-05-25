module ApplicationHelper
  def javascript(*files)
    content_for(:js_head) { javascript_include_tag(*files) }
  end

  def omniauth_authorize_path(provider)
    if provider.to_s == 'open_id'
      'https://openid.nus.edu.sg/auth'
    end
  end
end
