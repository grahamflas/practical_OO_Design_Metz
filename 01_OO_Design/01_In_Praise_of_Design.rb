=begin
_______________ IN PRAISE OF DESIGN _______________

"Each OO application gradually becomes a unique programming language that is specifically tailored to your domain.  Whether this language ultimately brings youo pleasure or give you pain is a matter of design."

### ___ Agile Development ___
Agile assumes that customers can't define the software they want until they see it. Impossible to plan out every feature that an application could have without using it first. Therefore, best to take an incremental, iterative approach rather than sinking costs into a Big Upfront Design (BUFD), because the BUFD by definition isn't going to be what the customer wants.

Software WILL change
  + Object-oriented design (OOD) techniques produce cost-effective software written in simple, reusable, malleable code that easily accomodates inevitable change. 
_

### ___ Object Oriented Languages ___
+ Class-based, OO languages combine data and behavior into a single thing:  an OBJECT
+ A CLASS serves as a blueprint for creating similar objects
+ a class has ATTRIBUTES (data) and METHODS (behavior)
+ Objects of a given class share attributes and methods but ENCAPSULATE their individual data and control how much of that data to expose
+ Objects invoke one another's behavior by sending messages 

### ___ Object Oriented Applications ___
+ OO applications are made up of parts that interact to produce the behavior of the whole
+ OO Design is about managing dependencies -- Set up dependencies such that objects can tolerate inevitable change
  + Don't design objects such that they "know too much"/ have too many expectations
    + Makes objects too picky, difficult to reuse in different contexts
    + Risks a minor change to one object triggering cascading changes throughout the application
  _

+ Practical design preserves your options for accomodating the future and minimizes the cost of change

=end
