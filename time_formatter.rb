class TimeFormatter

  FORMATS = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S'}.freeze

  def initialize
    @body = ''
    @unknown_format = []
  end

  def format_current_time(format)
    get_formats(format)
    DateTime.now.strftime(build_time_string)
  end

  def build_time_string
    time_string = ''
    @formats.each do |f|
      unless FORMATS.include? f
        unknown_format f.to_s
        next
      end
      time_string << FORMATS[f]
      time_string << ' '
    end
    time_string
  end

  def get_formats(query)
    @formats = query.split(',').map(&:to_sym)
  end

  def unknown_format(format)
    @unknown_format << format
  end

  def unknown_format?
    !@unknown_format.empty?
  end

  def body
    return @body + list_unknown_formats unless @unknown_format.empty?

    @body
  end

  def list_unknown_formats
    "\nUnknown time format #{@unknown_format.each.map(&:to_s)}"
  end
end