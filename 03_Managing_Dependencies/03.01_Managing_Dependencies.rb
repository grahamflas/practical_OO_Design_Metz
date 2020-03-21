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

class Gear_With_Dependencies
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

=begin

### _________ Writing Loosely Coupled Code ____________

## ______ Inject Dependencies ______

+ In the example above, the #gear_inches hard-codes a reference to the Wheel class so that it can send it the message #diameter
+ It's not the Wheel class itself that's important, #gear_inches just needs an object that responds to the message #diameter

+ Decouple the Gear and Wheel classes by moving the creation of Wheel outside of the Gear class
  + known as DEPENDENCY INJECTION

"Using dependency injenctiton to shape code relies on your ability tto recognize that the responsibility for knowing the name of a class and the responsibility for knowing the name of the message to send to that class may belong in different objects. Just becuase Gear needs to send #diameter somewhere doesn't mean that Gear should know about Wheel"

=end

class Gear_With_Dependency_Injection
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring  = chainring
    @cog        = cog
    @wheel      = wheel
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter * 2
  end
end

# Gear expects a "Duck" that knows #diameter
gear_duck = Gear_With_Dependency_Injection.new(52, 11, Wheel.new(26, 1.5))

=begin
## _______________ Isolate Dependences _______________
Sometimes constraints will prevent you from being able to remove unnecessary dependencies from a class. 
If this is the case, isolate those dependencies by
  + Explicitly exposing them
  + Reducing their reach into the class

Example below moves the creation of a Wheel object from inside #gear_inches to the class' #initialize method.
  1) Reveals the dependency
  2) Lowers the barrier to reuse
  3) Makes the code easier to refactor if circumstances allow
=end

class Gear_Isolated_Dependency
  attr_reader :chainring, :cog, :wheel
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
end

=begin
### _______________ Isolate External Messages _______________

An external message is one sent to someone other than `self`
In #gear_inches above, Gear sends 
  + two messages to self: `ratio` and `wheel`
  + one message to Wheel (i.e., not self): `diameter`

Imagine #gear_inches is a more complex method or that `wheel.diameter` is used throughout the class. 
This external message to Wheel makes Gear vulnerable to a change in the name or implementation of the #diameter method in Wheel

Mitigate the vulnerability posed by Gear's dependency on Wheel.diameter by preemptively encapsulating it in its own method
=end

class Gear_Encapsulated_External_Message
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = Wheel.new(rim, tire)
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * diameter
  end

  def diameter
    wheel.diameter
  end
end

=begin
### _______________ Remove Argument-Order Dependencies _______________
Many method signatures requre arguments to be passed in an a specific, fixed order.
Senders of those methods are required to know about this order and will have to change if the order or composition of the method's arguments changes.

SOLUTION: Use KEYWORD ARGUMENTS to avoid depending on positional arguments
Advantages of keyword arguments:
  + Arguments can be passed in any order
  + Methods that use keyword arguments can add or remove arguments and defaults without worrying about side effects to other code
Disadvantages of keyword arguments:
  + Objects that use keyword arguments are now dependent on the names of the keywords; however, this dependency is relatively more stable and easier to change
=end

class Gear_With_Keyword_Args
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring: 40, cog: 18, wheel:)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * diameter
  end

  def diameter
    wheel.diameter
  end
end

# Note, args passed to #new are backwards with respect to method signature of #initialize
Gear_With_Keyword_Args.new(
  wheel: Wheel.new(26, 1.5),
  cog: 11,
  chainring: 52 
)

#Use defaults
Gear_With_Keyword_Args.new(
  wheel: Wheel.new(26, 1.5)
)

=begin
### _______________ Removing Arg-Order Dependencies in External Interfaces _______________

Suppose:
  + Gear class is part of some external framework whose code you DO NOT own 
  + Gear depends on positional arguments
SOLUTION: encapsulate the instantiation of a new Gear object inside your own method to isolate the arg-order dependency
  + allows you to create a FACTORY that uses keyword arguments to instantiate a new Gear
=end

module SomeExternalFramework
  class Gear
    attr_reader :chainring, :cog, :wheel
    def initialize(chainring, cog, wheel)
      @chainring = chainring
      @cog       = cog
      @wheel     = wheel
    end

    def ratio
      chainring / cog.to_f
    end

    def gear_inch
      ratio * diameter
    end

    def diameter
      wheel.diameter
    end
  end
end

module GearWrapper
  def self.gear(chainring:, cog:, wheel:)
    SomeExternalFramework::Gear.new(chainring, cog, wheel)
  end
end