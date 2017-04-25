class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_after_action :verify_same_origin_request

  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
