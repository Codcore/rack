require 'rack'
require_relative 'time_formatter'

class TimeApp

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new
    @response['Content-Type'] = 'text/html'

    if @request.get? && @request.path == '/time' && @request.params['format']
      time_response
    else
      not_found_response
    end
    @response.finish
  end

  def time_response
    formatter = TimeFormatter.new
    formatter.body << formatter.format_current_time(@request.params['format'])
    @response.write(formatter.body)
    @response.status = 400 if formatter.unknown_format?
  end

  def not_found_response
    @response.status = 404
    @response.write('URL NOT SUPPORTED')
  end
end
