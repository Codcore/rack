require 'rack'
require_relative 'time_formatter'

class TimeApp

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response['Content-Type'] = 'text/html'
    response.status = 200
    formatter = TimeFormatter.new

    if request.get? && request.path == '/time' && request.params['format']
      formatter.body << formatter.format_current_time(request.params['format'])
      response.write(formatter.body)
      response.status = 400 if formatter.unknown_format?
    else
      response.status = 404
      response.write('URL NOT SUPPORTED')
    end
    response.finish
  end
end
