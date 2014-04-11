require File.expand_path('../../lib/em-websocket', __FILE__)
require 'json'

class Building
  def initialize
    @lifts = [
  	  	{
  			:liftAtFloor => 0, 
  			:doorsOpen => true, 
  			:peopleInLift => [{:goingTo => 1}, {:goingTo => 2}],
  			:direction => "UP"
  	  	},{
    			:liftAtFloor => 0, 
    			:doorsOpen => true, 
    			:peopleInLift => [{:goingTo => 1}, {:goingTo => 2}],
    			:direction => "UP"
    	  	}
		  ]
      
		  @floors = [
			{:peopleWaiting => [{:goingTo => 0}]},
			{:peopleWaiting => []},
			{:peopleWaiting => [{:goingTo => 1}, {:goingTo => 2}]}
		  ]
    end
  
  def to_json
    "{\"lifts\":" + @lifts.to_json + ", \"floors\":" + @floors.to_json + "}"
  end
end

building = Building.new

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => false) do |ws|
=begin
  timer = nil
  ws.onopen {
    timer = EM.add_periodic_timer(10) {
      ws.ping()
    }
  }
  ws.onpong { |value|
    puts "Received pong: #{value}"
  }
  ws.onping { |value|
    puts "Received ping: #{value}"
  }
=end
  ws.onclose {
    puts "WebSocket closed"
  }
  ws.onerror { |e|
    puts "Error: #{e.message}"
  }
  ws.onmessage { |message|
    if message.start_with?('getBuilding')
      puts "getBuilding request"
      ws.send( building.to_json)
    end
  }
end
