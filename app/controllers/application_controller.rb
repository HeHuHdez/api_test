# frozen_string_literal: true

# Base class for controllers
class ApplicationController < ActionController::API
  before_action :authorize!

  include Response
  include ExceptionHandler

  def authorize!
    authenticate_or_request_with_http_token do |token|
      unless (@user = User.find_by(auth_token: token, expires_at: Time.zone.now..DateTime::Infinity.new))
        return json_response({ status: 403, message: 'Unauthorized access' }, :forbidden)
      end
    end
  end
end
