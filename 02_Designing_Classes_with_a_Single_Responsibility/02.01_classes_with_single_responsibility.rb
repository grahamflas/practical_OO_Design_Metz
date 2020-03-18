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

