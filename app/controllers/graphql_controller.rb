# frozen_string_literal: true

class GraphqlController < ApplicationController
  rescue_from StandardError, with: :render_standard_error
  rescue_from ArgumentError, with: :render_argument_error
  rescue_from GraphQL::ExecutionError, with: :render_graphql_execution_error

  rescue_from GraphQL::Backtrace::TracedError do |error|
    render_standard_error(error.cause)
  end

  def params
    request.parameters
  end

  # GET or POST /graphql
  def execute
    query = params[:query]
    operation_name = params[:operationName]
    variables = ensure_hash(params[:variables])

    result = Schema.execute(query,
                            variables: variables,
                            context: context,
                            operation_name: operation_name)
    status = result['errors'].present? ? 422 : 200

    render status: status, json: JSON.dump(result) # use JSON::dump to avoid html escaping. https://stackoverflow.com/questions/17936318/why-does-to-json-escape-unicode-automatically-in-rails-4
  end

  # POST /graphql-introspect
  def introspect
    result = Schema.execute(params[:query], context: context)
    render json: result
  end

  protected def context
    @context ||= {}
  end

  protected def check_for_expired_password
    return unless current_user.present? && current_user.password_expired?

    Rails.logger.info "Request to GraphqlController#execute unauthorized due to an expired password for user #{current_user.email}"
    render status: :unauthorized, json: { errors: ['Password is expired'] } # halts request cycle
  end

  private def authenticate_with_introspect_auth_token!
    authorized = false

    authorization_header = request.headers['Authorization']
    authorized = (authorization_header == Rails.application.credentials.dig(:auth_token, :graphql_introspect)) if authorization_header.present?

    return if authorized

    Rails.logger.info "Unauthorized request to GraphqlController#introspect with authorization header: #{authorization_header}"
    head :unauthorized # halts request cycle
  end

  # Handle form data, JSON body, or a blank value
  private def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        begin
          parsed_json = JSON.parse(ambiguous_param)
          ensure_hash(parsed_json)
        rescue StandardError
          raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
        end
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  private def render_not_authorized_error(_error)
    render status: :unauthorized, json: { errors: ['Not Authorized'] } # 401
  end

  private def render_payment_required_error(_error)
    render status: :payment_required, json: { errors: ['Payment Required'] } # 402
  end

  private def render_argument_error(error)
    render status: :unprocessable_entity, json: { errors: [error.message] } # 422
  end

  private def render_graphql_execution_error(_error)
    render status: :unprocessable_entity, json: { errors: ["Unable to perform your GraphQL query: #{params[:query]}"] } # 422
  end

  private def render_standard_error(error)
    render status: :internal_server_error, json: { errors: ["Unable to perform your GraphQL query due to internal error: #{error.message}"] } # 500
  end
end
