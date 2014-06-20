class Building
  class Person
    attr_reader :going_to
    def initialize(going_to)
      @going_to = going_to
    end
  end
  
  class LiftEvents
    
    def initialize
      @available_lifts = Hash.new([])
    end
    
    def lift_doors_open(lift)
      lifts_at_floor = @available_lifts[lift.at_floor] << lift
      @available_lifts[lift.at_floor] = lifts_at_floor
    end
    
    def lift_doors_closed(lift)
      lifts_at_floor = @available_lifts[lift.at_floor]
      lifts_at_floor.delete(lift)
      @available_lifts[lift.at_floor] = lifts_at_floor
    end
    
    def lift_available(floor, going_up_or_down)
      @available_lifts[floor].find do |lift|
        return true if lift.people_in_lift.empty?
        return true if lift.people_in_lift.first.going_to > floor && going_up_or_down == :going_up
        return true if lift.people_in_lift.first.going_to < floor && going_up_or_down == :going_down
        return false
      end
    end
    
    def notify_when_lift_available(floor_number, going_up_or_down, person)
      
    end
    
  end
  
  class Lift
    attr_reader :at_floor, :calling_at
    
    def initialize(lift_events)
      @at_floor = 0
      @people_in_lift = []
      @lift_events = lift_events
    end
    
    def get_in(person)
      @people_in_lift << person
    end
      
  end
  
  class Floor
    def initialize(lift_events, floor_number)
      @people_waiting = []
      @lift_events = lift_events
      @floor_number = floor_number
    end
    
    def add_person(going_to)
      person = Person.new(going_to)
      going_up_or_down = :going_up if going_to > @floor_number else :going_down
      lift = @lift_events.lift_available(@floor_number, going_up_or_down)
      if lift == nil
        @lift_events.notify_when_lift_available(@floor_number, going_up_or_down, person)
        @people_waiting << person
      else 
        lift.get_in(person)
      end
    end
  end

  def initialize(floors, lifts)
    @lift_events = LiftEvents.new
    @lifts = (1..lifts).inject([]) {|lifts_so_far, lift_number| lifts_so_far << Lift.new(@lift_events)}
    @lifts.each {|lift| @lift_events.lift_doors_open(lift)}
    @floors = (0..floors-1).inject([]) {|floors_so_far, floor_number| floors_so_far << Floor.new(@lift_events, floor_number)}
  end
  
  def summon_lift(from_floor, to_floor)
    @floors[from_floor].add_person(to_floor) if from_floor != to_floor
  end
    
    
end