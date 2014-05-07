require 'thin'
require 'em-websocket'
require 'sinatra/base'

EM.run do
  class App< Sinatra::Base
    get '/' do
      erb :index
    end
    get "/app.js" do
      content_type "text/javascript"
      coffee :application
    end
  end

  @clients = []

  EM::WebSocket.start(:host => '0.0.0.0', :port => '3001') do |ws|

    ws.onopen do |handshake|
      @clients << ws
      puts "event"
      ws.send "Connected to #{handshake.path}."
    end

    ws.onclose do
      puts "event"

      ws.send "Closed."
      @clients.delete ws
    end

    ws.onmessage do |msg|
      puts "event"

      puts "Received Message: #{msg}"
      @clients.each do |socket|
        socket.send msg
      end
    end
  end

  App.run!
end
