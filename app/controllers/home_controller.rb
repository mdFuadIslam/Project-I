class HomeController < ApplicationController
  before_action:set_locale

  def set_locale
    I18n.locale = session[:lang]
  end
  def index
    session[:lang] ||= 'en'
    set_locale
  end

  def change_language
    session[:lang] = params[:lang]
    set_locale
    redirect_to request.referer
  end
end
