require_relative 'web_server_2'
require 'pry'

class PathRequest

  def initialize
    @server = WebServer.new
  end
end

PathRequest.new
