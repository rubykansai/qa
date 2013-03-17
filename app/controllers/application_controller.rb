class ApplicationController < ActionController::Base
  include ApplicationHelper # TODO Remove this line
  protect_from_forgery
  before_filter :set_gettext_locale
end

class PermissionError < StandardError; end
class EmptyDataError < StandardError; end
