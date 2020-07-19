# frozen_string_literal: true

# Module to put all json builders
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
