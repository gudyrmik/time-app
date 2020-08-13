class TimeFormatter
  ACCEPTABLE_FORMATS = ["year", "month", "day", "hour", "minute", "second"].freeze
  STRFTIME_FORMATS = ["%Y", "%m", "%d", "%H", "%M", "%S"].freeze
  HEADER = { 'Content-Type' => 'text/plain' }.freeze

  attr_reader :result

  def initialize(request_path, query_string)
    @result = parse_request(request_path, query_string)
  end

  private

  def parse_request(request_path, query_string)
    return [404, HEADER, ['Unknown URL']] unless request_path == '/time'
    query_hash = Rack::Utils.parse_nested_query(query_string)
    return [404, HEADER, ['Unknown param']] if query_hash['format'].nil?

    body_ok = ""
    body_failed = ""
    queried_formats = query_hash['format'].split(',')
    
    queried_formats.each_with_index do |time_format, index|
      if ACCEPTABLE_FORMATS.include?(time_format)
        body_ok += '-' unless body_ok.empty?
        body_ok += STRFTIME_FORMATS[index]
      else
        body_failed += ', ' unless body_failed.empty?
        body_failed += "#{time_format}"
      end
    end

    if body_failed.empty?
      [200, HEADER, [Time.now.strftime(body_ok)]]
    else
      [200, HEADER, ["Unknown time format [#{body_failed}]" ]]
    end
  end
end