require 'rack'

class TimeApp
  FORMATS = %i[year month day hour minute second]

  def call(env)
    @status = 200
    @body = []
    @unknown_format = []
    request = Rack::Request.new(env)
    if request.get? && request.path == "/time" && request.params["format"]
      # [200, headers, [request.get?.to_s, request.path.to_s, request.params.to_s ]]
      get_formats(request.params["format"])
      @body << DateTime.now.strftime(build_time_string)
      [@status, headers, body]
    else
      [404, headers, ['URL NOT SUPPORTED']]
    end
  end

  def build_time_string
    time_string = ""
    @formats.each do |f|
      unless FORMATS.include? f
        @status = 400
        unknown_format f.to_s
        next
      end
      case f
      when :year then time_string << "%Y-"
      when :month then time_string << "%m-"
      when :day then time_string << "%d-"
      when :hour then time_string << "%H:"
      when :minute then time_string << "%M:"
      when :second then time_string << "%S"
      end
    end
    time_string
  end

  def get_formats(query)
    @formats = query.split(',').map(&:to_sym)
  end

  def unknown_format(format)
    @unknown_format << format
  end

  def body
    return @body + list_unknown_formats unless @unknown_format.empty?
    @body
  end

  def list_unknown_formats
    ["\nUnknown time format #{@unknown_format.each.map(&:to_s)}"]
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
