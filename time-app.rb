require 'rack'
require_relative 'time_formatter'

class TimeApp
  def call(env)
    time_formatter = TimeFormatter.new(env["REQUEST_PATH"], env["QUERY_STRING"])
    time_formatter.result
  end
end