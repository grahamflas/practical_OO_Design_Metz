=begin

An OO application is made up of classes, but is characterized by the pattern of messages traded between objects.
Design must be concerned with the messages that pass between objects.
  + App design deals with what objects know (their responsibilities) and whom they know (their dependencies)
  + App design must also deal with HOW objects communicate with each other through INTERFACES

=end

=begin
### _______________ Understanding Interfaces _______________
An INTERFACE is the set of methods implemented by a class that is intended to be used by other classes

  + A well-designed class has constraints on its public interface-- a clearly defined st of methods that it expects others to use

  + Poorly-designed class exposes too much of itself-- it can be invoked by any object
=end

=begin
### _______________ Defining Interfaces _______________

RESTAURANT KITCHEN METAPHOR
+ A restaurant kitchen has a public interface with its customers:  
    + the menu 
    + Orders come in and are delivered out through an expo window
+ After an order is received, private messages are traded within the kitchen to fulfil customers orders -- this process isn't exposed to the customer  

Each class is like a kitchen
  + Class exists to fulfill a single responsibility, which is fulfilled using many methods
  + PUBLIC METHODS: methods that are broad and general and expose the responsibility of the class
  + PRIVATE METHODS: granular utility  methods that deal with internal implementation details
_

PUBLIC INTERFACES
Methods that comprise the face of a class
  + Reveal class's primary responsibility
  + Expect to be invoked by others
  + Won't change on a whim
  + Safe for others to depend on
  + Throughly documented in tests
_

PRIVATE INTERFACES
Methods that aren't outward-facing
  + Handle implementation details
  + Not expected to be sent by others
  + Unsafe for others to depend on
  + Might not be referenced in tests
_


=end