=begin
_______________ Designing Classes with a Single Responsibility _______________ 

Goals when designing an application
  1. Model using classes so that the app does what it needs to do right now
  2. Arrange code such that it's easy to change later
_

###_____ Deciding What Belongs in a Class _____
  + Challenge isn't writing the code, it's organizing it.
  + Methods need to be grouped into classes that define a virtual world, will shape the way you think about your application
  + Impossible to get it all right from the outset, so design with future changes in mind 

  + Code that is easy to change:
    + has no unexpected side-effects
    + small changes in specs require small changes in code
    + is reuseable
    + incorporates changes by adding code that is easy to change
  

  *** TRUE code
  + TRANSPARENT - consequences of changes in code should be obvious: 
    1) in the code you're changing
    2) in distant code that depends upon the code that's changing

  + REASONABLE - cost of change should be proportional to the benefits 

  + USEABLE - existing code can be used in new/ unexpected contexts

  + EXEMPLARY - ecourages those who change the code to perpetuate its qualities

### ___________________________________

### _____ Classes w/ a Single Responsibility _____
  + A class should do the smallest possible useful thing; have a single responsibility
  + Something in a domain is a candidate for a class if it has 
    + data
    + behavior 

  + Notes on the bicycle domain
    + A gear works by controlling how many times a bike wheel rotates for each pedal rotation
      + Low gear: feet pedal many times to make the wheel rotate once
      + High gear: each complete pedal leads wheel to spin multiple times

  + Compare gears by comparing the ratio of the number of teeth on the chainring (the part the pedals turn) to the number of teeth on the cog (the part on the wheel)
    + chainring = 52 (teeth)
    + cog = 11
    + ratio = chainring / cog #=> 4.7272727273 rotatations of the wheel each time 

  + Create a Gear class
  + Extend Gear class to account for differences in rim and tire size
    + Note that changing the number of arguments (adding tire and rim) introduces a bug by breaking all existing callers of the method
  
  + Creating the #gear_inches method required adding attributes to the model, which changed the number of arguments you need to pass to the #inititalize method, breaking all existing callers of that method.  This is fine for now, but you could easily imagine a number of calculator methods needing to be added as the application evolves.
### ___________________________________

### _____ Why Signle Responsibility Matters _____

  + Applications that are conducive to change are made up of reusable classes that can be selected and assembled in unanticipated ways
  + Reusable classes have 1) well-defined behavior and 2) few entanglements

  + A class that has more than one responsibility is difficult to reuse, becuase the responsibilities are likely entangled within the class, making it difficult to use only the behaviour you need
    + Result: 
      + 1) Violate DRY by duplicating your code -- hard to maintain, easy to introduce bugs
      + 2) You may end up reusing the entire over-burdened class in order to use only part of its responsibilities; possibility of the class needing to change, which may break the application in an unexpected way.

  + The Gear class defined below has more than one responsibility
    + How to tell
      1) Imagine you can interrogate the class, ask each of its methods as a question
          + Gear, what is your ratio?  #=> makes sense
          + Gear, what is your tire?  #=> DOES NOT make sense
      2) Describe the class in a single sentence without using AND or OR
        + "The Gear class calculates the effect that a gear has on a bicycle" --> rim and tire don't belong here
### ___________________________________

=end

class Gear_That_Does_Too_Much
  attr_reader :chainring,
              :cog,
              :rim,
              :tire

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim #diameter in inches
    @tire = tire #diameter in inches
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * (rim + (2 * tire))
  end
end

=begin
  
###_______________ Writing Code That Embraces Change _______________

### _____ Hide Messy Data Structures _____

  + Suppose you're working with messy external data 
    -- a 2-dimensional array of rim and tire sizes, where rim is at array[0] and tire is at array[1]

  + The class you create has methods that interact with this data by indexing into the array
    + PROBLEM, because any method you write DEPENDS on the structure of the external data
    + Any reference to the array's structure is LEAKY --that is, it escapes encapsulation an insinuates itself throughout your code

### _________________________
  
=end

# rim = data[0], tire =  data[1]
DATA = [[622,20], [622,23], [559,30], [559,40]]

class ObscuringReferences
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def diameters
    data.collect {|cell| cell[0] + (cell[1] * 2)}
  end
end

=begin
  + The class defined below has the exact same interface
    + Initialize using a 2D array
    + Implement #diameter

  + However, this implementation of #diameter has no knowledge of the internal structure of the array used ot  initialize the object -- instead, it knows that `wheels` returns an enumerable that responds to .rim and .tire
  + Encapsulate the structure of the incoming array using the #wheelify method, which returns an array of Structs
    + Struct is a way to bundle a number of attributes together using accessor methods without having to write an explicit class

  + The advantage of this style is that you're protecting against changes to the structure of your external data. Any change to the incoming data will be dealt with in the code that creates the Wheel Struct

=end

class RevealingReferences
  attr_reader :wheels
  def initialize(data)
    @wheels = wheelify(data)
  end

  def diameters
    wheels.map { |wheel| wheel.rim + (wheel.tire * 2) }
  end

  Wheel = Struct.new(:rim, :tire)

  def wheelify(data)
    data.map { |cell| Wheel.new(cell[0], cell[1]) }
  end
end

=begin
###_______________ Enforce Single Responsibility Everywhere _______________
  + Methods should also adhere to the single responsibility principle
    1) Ask them what they do
    2) Describe what they do in a single sentence without using AND or OR
    + Note that #diameters does two things -- it iterates over wheels AND it calculates the diameter
      + Split this into two methods
  
  + Separating iteration from the action that's being performed on each element is a common case of multiple responsibility that is easy to recognize
=end

def diameters
  wheels.map { |wheel| diameter(wheel) }
end

def diameter(wheel)
  wheel.rim + (wheel.tire *2)
end

=begin
###_______________ Isolate Extra Responsibilities in Classes _______________

  + Notice that the Gear has some Wheel-like behavior -- Likely need a Wheel class
  + Suppose you have design restrictions
    + Use Struct to isolate the wheel-like behavior without committing to a new class
=end

class Gear_with_Wheel
  attr_reader :chainring,
              :cog,
              :wheel

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = Wheel.new(rim, tire)
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end

  Wheel = Struct.new(:rim, :tire) do
    def diameter
      rim + (tire * 2)
    end
  end
end

=begin
  + Using Struct as above suggests that a Wheel wouldn't exist in isolation from a Gear -- we know that's not true, so separate Wheel into its own class
=end
