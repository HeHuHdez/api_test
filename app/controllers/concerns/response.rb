# frozen_string_literal: true

# Module to put all json builders
module Response
  def json_response(object, status = :ok, location = nil, include = nil)
    render json: object, status: status, location: location, include: include
  end
end
