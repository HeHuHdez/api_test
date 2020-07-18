# frozen_string_literal: true

module Api
  # Sessions controller
  class SessionsController < ApplicationController
    skip_before_action :authorize!

    def create
      user = User.find_by(email: params[:email].downcase)
      if user&.authenticate(params[:password])
        user.regenerate_auth_token
        json_response({ auth_token: user.auth_token, expires_at: user.expires_at })
      else
        json_response({ status: 401, message: 'Bad credentials' }, 401)
      end
    end
  end
end
