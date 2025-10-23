# PlantUML Diagrams

PlantUML is a versatile tool for creating UML diagrams using simple text descriptions. This page demonstrates various PlantUML diagram types and syntax.

## Sequence Diagrams

### Basic Interaction

```plantuml
@startuml
actor User
User -> App: open docs
App -> Kroki: render via HTTP
Kroki --> App: return SVG
App --> User: display diagram
@enduml
```

### Complex API Flow

```plantuml
@startuml
participant "Web Browser" as Browser
participant "Load Balancer" as LB
participant "API Gateway" as Gateway
participant "Auth Service" as Auth
participant "User Service" as UserSvc
database "User DB" as DB

Browser -> LB: HTTPS Request
LB -> Gateway: Forward Request
Gateway -> Auth: Validate Token
Auth --> Gateway: Token Valid

alt Valid Token
    Gateway -> UserSvc: Get User Data
    UserSvc -> DB: Query User
    DB --> UserSvc: User Data
    UserSvc --> Gateway: User Response
    Gateway --> LB: Success Response
    LB --> Browser: 200 OK
else Invalid Token
    Auth --> Gateway: Token Invalid
    Gateway --> LB: 401 Unauthorized
    LB --> Browser: 401 Error
end
@enduml
```

## Class Diagrams

### Basic Class Structure

```plantuml
@startuml
class User {
    -String name
    -String email
    -String password
    +login()
    +logout()
    +updateProfile()
}

class Order {
    -String id
    -Date createdAt
    -BigDecimal total
    +addItem(Product)
    +removeItem(Product)
    +calculateTotal()
}

class Product {
    -String name
    -BigDecimal price
    -String description
    +updatePrice(BigDecimal)
    +getDiscountedPrice()
}

User ||--o{ Order : places
Order ||--o{ Product : contains
@enduml
```

### Advanced Class Relationships

```plantuml
@startuml
abstract class Animal {
    #String name
    #int age
    +{abstract} makeSound()
    +move()
}

class Dog extends Animal {
    -String breed
    +makeSound()
    +fetch()
}

class Cat extends Animal {
    -boolean indoor
    +makeSound()
    +climb()
}

interface Flyable {
    +fly()
    +land()
}

class Bird extends Animal implements Flyable {
    -int wingspan
    +makeSound()
    +fly()
    +land()
}

class Owner {
    -String name
    -String address
}

Owner ||--o{ Animal : owns
@enduml
```

## Use Case Diagrams

### System Overview

```plantuml
@startuml
left to right direction

actor "Documentation Writer" as Writer
actor "Documentation Reader" as Reader
actor "System Administrator" as Admin

rectangle "Documentation System" {
    usecase "Create Content" as UC1
    usecase "Edit Content" as UC2
    usecase "View Content" as UC3
    usecase "Search Content" as UC4
    usecase "Manage Users" as UC5
    usecase "Deploy Site" as UC6
    usecase "Monitor System" as UC7
}

Writer --> UC1
Writer --> UC2
Reader --> UC3
Reader --> UC4
Admin --> UC5
Admin --> UC6
Admin --> UC7

UC1 ..> UC3 : includes
UC2 ..> UC3 : includes
@enduml
```

## Activity Diagrams

### Documentation Workflow

```plantuml
@startuml
start

:Writer creates content;

if (Content ready?) then (yes)
    :Submit for review;
    
    if (Review approved?) then (yes)
        :Publish content;
        :Notify stakeholders;
        stop
    else (no)
        :Return to writer with feedback;
        :Writer revises content;
    endif
    
else (no)
    :Continue writing;
endif

@enduml
```

### Deployment Process

```plantuml
@startuml
|#LightBlue|Developer|
start
:Push code to repository;

|#LightGreen|CI/CD System|
:Trigger build;
:Run tests;

if (Tests pass?) then (yes)
    :Build documentation;
    if (Build successful?) then (yes)
        :Deploy to staging;
        
        |#LightCoral|QA Team|
        :Review staging site;
        
        if (QA approved?) then (yes)
            |#LightGreen|CI/CD System|
            :Deploy to production;
            :Notify team;
            stop
        else (no)
            |#LightBlue|Developer|
            :Fix issues;
        endif
    else (no)
        |#LightBlue|Developer|
        :Fix build errors;
    endif
else (no)
    |#LightBlue|Developer|
    :Fix failing tests;
endif

@enduml
```

## Component Diagrams

### System Architecture

```plantuml
@startuml
package "Frontend" {
    [Web Browser]
    [Mobile App]
}

package "API Layer" {
    [Load Balancer]
    [API Gateway]
    [Authentication Service]
}

package "Business Logic" {
    [User Service]
    [Order Service]
    [Product Service]
}

package "Data Layer" {
    database "User DB"
    database "Product DB"
    database "Order DB"
}

package "External Services" {
    [Payment Gateway]
    [Email Service]
    [Analytics]
}

[Web Browser] --> [Load Balancer] : HTTPS
[Mobile App] --> [Load Balancer] : HTTPS
[Load Balancer] --> [API Gateway]
[API Gateway] --> [Authentication Service]
[API Gateway] --> [User Service]
[API Gateway] --> [Order Service]
[API Gateway] --> [Product Service]

[User Service] --> [User DB]
[Product Service] --> [Product DB]
[Order Service] --> [Order DB]
[Order Service] --> [Payment Gateway]
[User Service] --> [Email Service]
[API Gateway] --> [Analytics]
@enduml
```

## State Diagrams

### Order State Machine

```plantuml
@startuml
[*] --> Draft
Draft --> Submitted : submit()
Submitted --> InReview : assign_reviewer()
InReview --> Approved : approve()
InReview --> Rejected : reject()
Rejected --> Draft : revise()
Approved --> Published : publish()
Published --> Archived : archive()
Archived --> [*]

Draft --> [*] : cancel()
Submitted --> [*] : cancel()
@enduml
```

## Deployment Diagrams

### Infrastructure Overview

```plantuml
@startuml
node "Load Balancer" {
    artifact "nginx"
}

node "Web Server 1" {
    artifact "docs-app"
    artifact "kroki-service"
}

node "Web Server 2" {
    artifact "docs-app"
    artifact "kroki-service"
}

database "Content Storage" {
    folder "markdown-files"
    folder "static-assets"
}

cloud "CDN" {
    artifact "cached-content"
}

"Load Balancer" --> "Web Server 1"
"Load Balancer" --> "Web Server 2"
"Web Server 1" --> "Content Storage"
"Web Server 2" --> "Content Storage"
"Load Balancer" --> "CDN"
@enduml
```

## Timing Diagrams

### Request Processing

```plantuml
@startuml
robust "User Request" as UR
robust "Load Balancer" as LB
robust "API Gateway" as AG
robust "Service" as SVC
robust "Database" as DB

@0
UR is Request
LB is Idle
AG is Idle
SVC is Idle
DB is Idle

@100
UR is Waiting
LB is Processing
AG is Idle
SVC is Idle
DB is Idle

@200
UR is Waiting
LB is Forwarding
AG is Processing
SVC is Idle
DB is Idle

@300
UR is Waiting
LB is Waiting
AG is Forwarding
SVC is Processing
DB is Idle

@400
UR is Waiting
LB is Waiting
AG is Waiting
SVC is Querying
DB is Processing

@500
UR is Waiting
LB is Waiting
AG is Waiting
SVC is Responding
DB is Idle

@600
UR is Receiving
LB is Responding
AG is Responding
SVC is Idle
DB is Idle

@700
UR is Complete
LB is Idle
AG is Idle
SVC is Idle
DB is Idle
@enduml
```

## Network Diagrams

### System Topology

```plantuml
@startuml
nwdiag {
  network Frontend {
      address = "192.168.1.0/24"
      web01 [address = "192.168.1.10"];
      web02 [address = "192.168.1.11"];
  }
  
  network DMZ {
      address = "10.0.1.0/24"
      web01 [address = "10.0.1.10"];
      web02 [address = "10.0.1.11"];
      api01 [address = "10.0.1.20"];
      api02 [address = "10.0.1.21"];
  }
  
  network Backend {
      address = "10.0.2.0/24"
      api01 [address = "10.0.2.20"];
      api02 [address = "10.0.2.21"];
      db01 [address = "10.0.2.30"];
      db02 [address = "10.0.2.31"];
  }
}
@enduml
```

## Syntax Tips

### Basic Elements

- **Actors**: `actor Name` or `participant Name`
- **Arrows**: `A -> B` (solid), `A --> B` (dashed)
- **Self-calls**: `A -> A`
- **Notes**: `note left: Text` or `note right: Text`
- **Activation**: `activate A` / `deactivate A`

### Styling and Colors

```plantuml
@startuml
participant "User" as U #LightBlue
participant "System" as S #LightGreen
database "Database" as D #Yellow

U -> S: Request
activate S #Red
S -> D: Query
D --> S: Result
S --> U: Response
deactivate S
@enduml
```

### Grouping and Dividers

```plantuml
@startuml
== Initialization ==
User -> System: Start
System -> Database: Connect

== Main Process ==
User -> System: Process Data
System -> Database: Store Data

== Cleanup ==
System -> Database: Disconnect
System -> User: Complete
@enduml
```

## Best Practices

1. **Use Meaningful Names** - Choose descriptive names for actors and objects
2. **Keep Diagrams Focused** - One concept per diagram
3. **Use Consistent Styling** - Apply consistent colors and formatting
4. **Add Notes** - Explain complex interactions with notes
5. **Group Related Items** - Use packages and groups for organization

## Advanced Features

### Skinparam Customization

```plantuml
@startuml
skinparam backgroundColor #EEEBDC
skinparam handwritten true
skinparam sequence {
    ArrowColor DeepSkyBlue
    ActorBorderColor DeepSkyBlue
    LifeLineBorderColor blue
    LifeLineBackgroundColor #A9DCDF
}

actor User
User -> System: Hello
System -> Database: Query
Database --> System: Result
System --> User: Response
@enduml
```

## Resources

- [PlantUML Documentation](https://plantuml.com/)
- [PlantUML Language Reference](https://plantuml.com/guide)
- [Real World PlantUML](https://real-world-plantuml.com/)
- [PlantUML Online Editor](https://www.plantuml.com/plantuml/uml/)