=begin
_______________ Designing Classes with a Single Responsibility _______________ 

Goals when designing an application
  1. Model using classes so that the app does what it needs to do right now
  2. Arrange code such that it's easy to change later
_

### _____ Deciding What Belongs in a Class _____
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

    + Create a gear class
=end

class Gear
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
