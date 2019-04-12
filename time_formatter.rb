class TimeFormatter
  attr_reader :body, :status

  FORMATS = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S'}.freeze

  def initialize
    @status = 200
    @body = []
    @unknown_format = []
  end

  def build_time_string
    time_string = ''
    @formats.each do |f|
      unless FORMATS.include? f
        @status = 400
        unknown_format f.to_s
        next
      end
      time_string << FORMATS[f]
      time_string << " "
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