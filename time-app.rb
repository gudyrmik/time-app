require 'rack'
require_relative 'time_formatter'

class TimeApp
  HTTP_HEADERS =  {
                    'HTTP_PLAIN' => { 'Content-Type' => 'text/plain' }
                  }.freeze
  HTTP_STATUSES = {
                    'HTTP_OK' => 200,
                    'HTTP_BAD_REQUEST' => 400,
                    'HTTP_NOT_FOUND' => 404
                  }.freeze

  def call(env)
    request_path = env["REQUEST_PATH"]
    query_string = env["QUERY_STRING"]
    return create_response(HTTP_STATUSES['HTTP_NOT_FOUND'], HTTP_HEADERS['HTTP_PLAIN'], 'Unknown URL') unless request_path == '/time'

    time_formatter = TimeFormatter.new(request_path, query_string)

    if time_formatter.valid?
      create_response(HTTP_STATUSES['HTTP_OK'], HTTP_HEADERS['HTTP_PLAIN'], time_formatter.response)
    else
      create_response(HTTP_STATUSES['HTTP_BAD_REQUEST'], HTTP_HEADERS['HTTP_PLAIN'], time_formatter.response)
    end
  end

  private

  def create_response(status, header, body)
    [status, header, [body]]
  end
end