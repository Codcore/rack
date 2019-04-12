require 'rack'
require_relative 'time_formatter'

class TimeApp

  def call(env)
    formatter = TimeFormatter.new
    request = Rack::Request.new(env)
    if request.get? && request.path == "/time" && request.params["format"]
      # [200, headers, [request.get?.to_s, request.path.to_s, request.params.to_s ]]
      formatter.get_formats(request.params["format"])
      formatter.body << DateTime.now.strftime(formatter.build_time_string)
      [formatter.status, formatter.headers, formatter.body]
    else
      [404, formatter.headers, ['URL NOT SUPPORTED']]
    end
  end


end
