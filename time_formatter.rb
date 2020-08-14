class TimeFormatter
  ACCEPTABLE_FORMATS = ["year", "month", "day", "hour", "minute", "second"].freeze
  STRFTIME_FORMATS = ["%Y", "%m", "%d", "%H", "%M", "%S"].freeze

  attr_reader :response

  def initialize(request_path, query_string)
    @response = parse(request_path, query_string)
  end

  def valid?
    @response.include?('Unknown') == false && @response.nil? == false
  end

  private 

  def parse(request_path, query_string)
    body_ok = ""
    body_failed = ""
    queried_formats = Rack::Utils.parse_nested_query(query_string)['format'].split(',')
    
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
      Time.now.strftime(body_ok)
    else
      "Unknown time format [#{body_failed}]"
    end
  end
end