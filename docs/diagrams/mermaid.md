# Mermaid Diagrams

Mermaid is a powerful diagramming tool that uses simple text-based syntax to create beautiful diagrams. This page demonstrates various Mermaid diagram types you can use in your documentation.

## Flowcharts

### Basic Flowchart

```mermaid
flowchart LR
    A[Start] --> B{Decision}
    B -->|Yes| C[Process A]
    B -->|No| D[Process B]
    C --> E[End]
    D --> E
```

### Complex Workflow

```mermaid
flowchart TD
    A[User Request] --> B{Authentication}
    B -->|Valid| C[Process Request]
    B -->|Invalid| D[Return Error]
    C --> E{Data Valid?}
    E -->|Yes| F[Save to Database]
    E -->|No| G[Validation Error]
    F --> H[Send Response]
    G --> I[Return Validation Message]
    D --> J[Log Error]
    H --> K[End]
    I --> K
    J --> K
```

## Sequence Diagrams

### API Interaction

```mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant API
    participant Database

    User->>Frontend: Submit Form
    Frontend->>API: POST /api/users
    API->>Database: INSERT user
    Database-->>API: Success
    API-->>Frontend: 201 Created
    Frontend-->>User: Success Message
```

### Authentication Flow

```mermaid
sequenceDiagram
    participant Client
    participant AuthServer
    participant ResourceServer

    Client->>AuthServer: Login Request
    AuthServer->>Client: Access Token
    Client->>ResourceServer: API Request + Token
    ResourceServer->>AuthServer: Validate Token
    AuthServer-->>ResourceServer: Token Valid
    ResourceServer-->>Client: API Response
```

## Class Diagrams

### Simple Class Structure

```mermaid
classDiagram
    class User {
        +String name
        +String email
        +String password
        +login()
        +logout()
        +updateProfile()
    }
    
    class Order {
        +String id
        +Date createdAt
        +Float total
        +addItem()
        +removeItem()
        +checkout()
    }
    
    class Product {
        +String name
        +Float price
        +String description
        +updatePrice()
    }
    
    User ||--o{ Order : places
    Order ||--o{ Product : contains
```

## State Diagrams

### Document Workflow

```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Review : submit
    Review --> Approved : approve
    Review --> Draft : reject
    Approved --> Published : publish
    Published --> Archived : archive
    Archived --> [*]
    
    Draft --> [*] : delete
    Review --> [*] : delete
```

## Gantt Charts

### Project Timeline

```mermaid
gantt
    title Documentation Project Timeline
    dateFormat  YYYY-MM-DD
    section Planning
    Requirements    :done, req, 2024-01-01, 2024-01-05
    Design         :done, design, 2024-01-06, 2024-01-12
    
    section Development
    Setup          :done, setup, 2024-01-13, 2024-01-15
    Core Features  :active, core, 2024-01-16, 2024-01-30
    Documentation  :doc, after core, 10d
    
    section Testing
    Testing        :test, after core, 5d
    Review         :review, after test, 3d
    
    section Deployment
    Deploy         :deploy, after review, 2d
```

## Git Graphs

### Branch Strategy

```mermaid
gitgraph
    commit id: "Initial"
    branch develop
    checkout develop
    commit id: "Setup"
    commit id: "Feature A"
    
    branch feature-b
    checkout feature-b
    commit id: "Feature B"
    
    checkout develop
    merge feature-b
    commit id: "Integration"
    
    checkout main
    merge develop
    commit id: "Release v1.0"
```

## Pie Charts

### Usage Statistics

```mermaid
pie title Documentation Page Views
    "Getting Started" : 35
    "API Reference" : 25
    "Tutorials" : 20
    "Examples" : 15
    "FAQ" : 5
```

## Entity Relationship Diagrams

### Database Schema

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    ORDER_ITEM }|--|| PRODUCT : references
    PRODUCT ||--o{ CATEGORY : belongs_to
    
    USER {
        int id PK
        string name
        string email
        string password_hash
        datetime created_at
    }
    
    ORDER {
        int id PK
        int user_id FK
        float total
        datetime created_at
        string status
    }
    
    ORDER_ITEM {
        int id PK
        int order_id FK
        int product_id FK
        int quantity
        float price
    }
    
    PRODUCT {
        int id PK
        string name
        string description
        float price
        int category_id FK
    }
    
    CATEGORY {
        int id PK
        string name
        string description
    }
```

## User Journey

### Customer Experience

```mermaid
journey
    title Customer Purchase Journey
    section Discovery
      Visit Website     : 5: Customer
      Browse Products   : 4: Customer
      Read Reviews      : 4: Customer
    section Evaluation
      Compare Options   : 3: Customer
      Check Pricing     : 4: Customer
      Contact Support   : 5: Customer, Support
    section Purchase
      Add to Cart       : 5: Customer
      Checkout Process  : 4: Customer
      Payment           : 3: Customer
    section Post-Purchase
      Receive Product   : 5: Customer
      Leave Review      : 4: Customer
      Recommend         : 5: Customer
```

## Syntax Tips

### Basic Elements

- **Rectangles**: `A[Text]`
- **Rounded rectangles**: `A(Text)`  
- **Circles**: `A((Text))`
- **Asymmetric**: `A>Text]`
- **Rhombus**: `A{Text}`
- **Hexagon**: `A{{Text}}`

### Arrows and Links

- **Arrow**: `A --> B`
- **Open link**: `A --- B`
- **Text on link**: `A -->|Text| B`
- **Dotted link**: `A -.-> B`
- **Thick link**: `A ==> B`

### Styling

You can add CSS classes and styles:

```mermaid
flowchart LR
    A[Normal] --> B[Success]:::success
    A --> C[Error]:::error
    A --> D[Warning]:::warning
    
    classDef success fill:#d4edda,stroke:#155724
    classDef error fill:#f8d7da,stroke:#721c24
    classDef warning fill:#fff3cd,stroke:#856404
```

## Best Practices

1. **Keep it Simple** - Don't overcomplicate diagrams
2. **Use Clear Labels** - Make node text descriptive
3. **Logical Flow** - Follow natural reading patterns (left-to-right, top-to-bottom)
4. **Consistent Styling** - Use consistent shapes and colors for similar elements
5. **Test Rendering** - Always preview your diagrams to ensure they render correctly

## Resources

- [Mermaid Documentation](https://mermaid.js.org/)
- [Mermaid Live Editor](https://mermaid.live/)
- [Syntax Reference](https://mermaid.js.org/syntax/flowchart.html)
- [Examples Gallery](https://mermaid.js.org/syntax/examples.html)