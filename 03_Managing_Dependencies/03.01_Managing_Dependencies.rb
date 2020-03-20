=begin

Objects pass messages to invoke behavior. This behavior comes from one of three sources
  1) The class that the object belongs to implements it personally
  2) The object inherits the behavior
  3) The object accesses the behavior through another object, called a dependency

Well-designed objects have a single responsibility; therefore, they need to collaborate with other objects through dependencies, which need to be carefully managed.

=end

=begin
### _______________ Understanding Dependencies _______________

An object depends on another object if, when one changes, the other might be forced to change in turn

Below is an example of a Gear object that has 4 dependencies on Wheel
  + these dependencies aren't necessary and are a result of the coding style
  + these dependencies make Gear harder to change

=end

class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @rim       = rim
    @tire      = tire
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
  end

  def ratio
    chainring / cog.to_f
  end

end

class Wheel
  attr_reader :rim, :tire
  def initialize(rim, tire)
    @rim  = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end
end

=begin
### _________ Recognizing Dependencies _________

An object has a dependency when it knows
  1) The name of another class
      + Gear expects Wheel to exist

  2) The name of a message that it intends to send to someone other than self.
      + Gear knows that Wheel responds to #diameter

  3) The arguments a message requires
      + Gear knows what is needed to initialize a Wheel

  4) The order of arguments for a message that another object responds to

Some dependencies are inevitable, because object must collaborate. However, design challenge is to minimize dependencies
=end

