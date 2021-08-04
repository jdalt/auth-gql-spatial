# frozen_string_literal: true

class Schema < GraphQL::Schema
  use GraphQL::Backtrace
  # use GraphQL::Execution::Interpreter

  # instrument :query, GraphQL::Metrics::Instrumentation.new
  # tracer GraphQL::Metrics::Tracer.new

  rescue_from(ActiveRecord::RecordNotFound) do |error|
    model_name = I18n.t("gql_errors.not_found.#{error.model}", default: error.model)
    raise GraphQL::ExecutionError, "#{model_name} not found"
  end

  rescue_from(ActiveRecord::RecordNotDestroyed) do |_error|
    raise GraphQL::ExecutionError, 'Unable to destroy record'
  end

  rescue_from(ActiveRecord::RecordInvalid) do |error|
    # NOTE: error.record.errors.details is accessible here
    error = error.message.sub(/Validation failed:\s/, '') # remove the first part of the error message, don't want to return to the client
    raise GraphQL::ExecutionError, error
  end

  rescue_from(ActiveRecord::RecordNotSaved) do |_error|
    raise GraphQL::ExecutionError, 'Unable to save record'
  end

  default_max_page_size 1000

  query Types::Query
  # mutation Types::Mutation

  # enable batch loading
  use BatchLoader::GraphQL

  # def self.unauthorized_object(error)
  #   context = error.context
  # end
end
