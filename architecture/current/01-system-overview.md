# System Overview - Current POC Architecture

[← Back to Architecture Overview](../../ARCHITECTURE_CURRENT_POC.md)

---

## Purpose

This document provides a high-level overview of the Training Tracker POC system architecture, including the system context, technology stack, key characteristics, and design principles that guide implementation decisions.

---

## System Context

### What is the Training Tracker?

The Training Tracker is a web-based application designed to help organizations manage employee training requirements, course catalogs, enrollments, and certification tracking. It provides:

- **For Employees:** View assigned training, enroll in courses, track completion status
- **For Managers:** Monitor team training compliance, assign courses
- **For Administrators:** Manage course catalog, user management, system-wide statistics

### System Boundaries

**In Scope:**
- Training course catalog management (CRUD operations)
- User profile management
- Course enrollment tracking
- Training completion and status management
- Basic reporting and statistics
- Administrative dashboard

**Out of Scope (Future):**
- Integration with HR systems
- Learning Management System (LMS) integration
- Advanced analytics and reporting
- Certificate generation
- Email notifications
- Mobile applications
- Third-party SSO integration

### System Context Diagram

```
                           ┌─────────────────┐
                           │   Web Browser   │
                           │                 │
                           │  Users:         │
                           │  • Employees    │
                           │  • Managers     │
                           │  • Admins       │
                           └────────┬────────┘
                                    │
                                    │ HTTPS (Future)
                                    │ HTTP (Current)
                                    │
                    ┌───────────────▼───────────────┐
                    │                               │
                    │  Training Tracker Web App     │
                    │  (POC Implementation)         │
                    │                               │
                    │  ┌─────────┐   ┌──────────┐  │
                    │  │ React   │   │ ASP.NET  │  │
                    │  │ SPA     │◄─►│ Core API │  │
                    │  │         │   │          │  │
                    │  └─────────┘   └────┬─────┘  │
                    │                     │         │
                    └─────────────────────┼─────────┘
                                          │
                                          │ SQL/TDS
                                          │
                              ┌───────────▼──────────┐
                              │  SQL Server LocalDB  │
                              │  POC_SpecKit1Local   │
                              │                      │
                              │  Schema: training    │
                              └──────────────────────┘

External Systems (Future):
• Email Service (notifications)
• Azure AD (authentication)
• HR System (employee sync)
• Learning Management System
```

---

## Technology Stack

### Frontend Stack

| Technology | Version | Purpose | Rationale |
|------------|---------|---------|-----------|
| **React** | 18.3 | UI framework | Modern, component-based architecture with excellent tooling |
| **TypeScript** | 5.5 | Type system | Type safety, better IDE support, reduced runtime errors |
| **Vite** | 5.4 | Build tool | Fast dev server, optimized production builds, HMR |
| **React Router** | 6.x | Client-side routing | Standard routing library, declarative routing |
| **Axios** | 1.x | HTTP client | Promise-based, interceptor support, better error handling |
| **CSS Modules** | N/A | Styling | Scoped styles, no global conflicts, TypeScript integration |

**Why Not Alternatives?**
- **Not using Tailwind CSS:** CSS Modules provide better TypeScript integration and scoped styling without additional build config
- **Not using Next.js:** POC doesn't require SSR; Vite provides faster dev experience
- **Not using Redux:** Application state is simple enough for React Context API

### Backend Stack

| Technology | Version | Purpose | Rationale |
|------------|---------|---------|-----------|
| **ASP.NET Core** | 8.0 | Web framework | Enterprise-grade, high performance, excellent Azure integration |
| **C#** | 12 | Programming language | Type-safe, modern language features, strong tooling |
| **Entity Framework Core** | 8.0 | ORM | Object-relational mapping, LINQ queries, change tracking |
| **Swagger/OpenAPI** | 3.0 | API documentation | Auto-generated API docs, testable endpoints |
| **System.Text.Json** | Built-in | JSON serialization | High performance, modern API, source generators |

**Why Not Alternatives?**
- **Not using Node.js:** Team expertise in .NET, better type safety, performance
- **Not using Dapper:** EF Core provides good balance of productivity and performance for POC
- **Not using MongoDB:** Relational data model fits well with SQL

### Database Stack

| Technology | Version | Purpose | Rationale |
|------------|---------|---------|-----------|
| **SQL Server** | LocalDB 2019+ | Database engine | Proven relational database, SSDT support, Azure SQL compatibility |
| **SSDT** | Latest | Schema management | Declarative DDL, version control for schema, DACPAC deployment |
| **LocalDB** | Instance | Dev database | Lightweight, no installation, suitable for development |

**Why Not Alternatives?**
- **Not using SQLite:** SQL Server better matches production Azure SQL Database
- **Not using PostgreSQL:** Team expertise with SQL Server, better Azure integration
- **Not using EF Migrations:** SSDT provides better enterprise-grade schema management (see ADR-001)

---

## Key Architectural Characteristics

### 1. **Layered Architecture**

The application follows a classic 3-tier layered architecture:

```
┌──────────────────────────────────────────────┐
│         Presentation Layer (React)           │
│  • Pages, Components, Routing                │
│  • User interactions, form validation        │
└─────────────────┬────────────────────────────┘
                  │ REST API (JSON/HTTP)
┌─────────────────▼────────────────────────────┐
│       Application Layer (ASP.NET Core)       │
│                                              │
│  ┌────────────────────────────────────────┐ │
│  │  Controllers (HTTP Endpoints)          │ │
│  └──────────────┬─────────────────────────┘ │
│                 │                            │
│  ┌──────────────▼─────────────────────────┐ │
│  │  Services (Business Logic)             │ │
│  └──────────────┬─────────────────────────┘ │
│                 │                            │
│  ┌──────────────▼─────────────────────────┐ │
│  │  Repositories (Data Access)            │ │
│  └──────────────┬─────────────────────────┘ │
└─────────────────┼────────────────────────────┘
                  │ SQL/TDS Protocol
┌─────────────────▼────────────────────────────┐
│         Data Layer (SQL Server)              │
│  • Tables, Views, Stored Procedures          │
│  • Constraints, Indexes                      │
└──────────────────────────────────────────────┘
```

**Benefits:**
- Clear separation of concerns
- Each layer has specific responsibilities
- Easier to test individual layers
- Changes to one layer have minimal impact on others

### 2. **Client-Server Architecture**

- **Client (SPA):** Runs entirely in browser, makes API calls for data
- **Server (API):** Stateless REST API, no session state
- **Separation:** Frontend and backend can be deployed independently

### 3. **Repository Pattern**

Abstract data access logic:
- Interfaces define contracts (`ICourseRepository`, `IUserRepository`)
- Implementations handle data access (`EfCourseRepository`, `InMemoryCourseRepository`)
- Services depend on interfaces, not concrete implementations

### 4. **Service Layer Pattern**

Business logic isolated from HTTP concerns:
- Services orchestrate repository operations
- Enforce business rules and validation
- Provide reusable business logic

### 5. **RESTful API Design**

- Resource-based URLs (`/api/courses`, `/api/users`)
- Standard HTTP verbs (GET, POST, PUT, DELETE)
- Proper HTTP status codes (200, 201, 400, 404, 500)
- JSON request/response bodies

---

## Design Principles

### 1. **Separation of Concerns**

Each component has a single, well-defined responsibility:
- **Controllers:** Handle HTTP requests/responses
- **Services:** Implement business logic
- **Repositories:** Manage data persistence
- **DTOs:** Define API contracts
- **Entities:** Represent domain models

### 2. **Dependency Inversion**

- High-level modules depend on abstractions (interfaces)
- Implementations injected via dependency injection
- Makes testing easier (can mock dependencies)

### 3. **SOLID Principles**

- **S**ingle Responsibility: Each class has one reason to change
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subtypes must be substitutable for base types
- **I**nterface Segregation: Many specific interfaces > one general
- **D**ependency Inversion: Depend on abstractions, not concretions

### 4. **DRY (Don't Repeat Yourself)**

- Reusable components (Button, Card, Table)
- Shared services and utilities
- Common middleware for cross-cutting concerns

### 5. **YAGNI (You Aren't Gonna Need It)**

- Implement only what's needed for POC
- Avoid over-engineering and premature optimization
- Defer complex features until validated

### 6. **Convention over Configuration**

- Follow ASP.NET Core conventions
- Use standard React patterns
- Minimal custom configuration

---

## Architectural Qualities

### Performance

| Quality | Target | Current Status |
|---------|--------|----------------|
| **API Response Time (p95)** | <1000ms | ✅ <500ms (local) |
| **Page Load Time** | <3s | ✅ <2s (dev mode) |
| **Time to Interactive** | <5s | ✅ <3s |
| **Database Query Time** | <100ms | ✅ <50ms (simple queries) |

### Scalability

| Dimension | POC Limit | Enterprise Target |
|-----------|-----------|-------------------|
| **Concurrent Users** | 1-5 | 500+ |
| **Database Size** | <100MB | 50GB+ |
| **Requests/sec** | <10 | 1000+ |
| **Data Volume** | 100 courses, 50 users | 10K courses, 10K users |

**Current Limitations:**
- No caching layer
- No load balancing
- Single-instance deployment
- No auto-scaling

### Security

| Security Control | POC Status | Notes |
|------------------|------------|-------|
| **Authentication** | ⚠️ Placeholder | Hardcoded user (alice@example.com) |
| **Authorization** | ❌ Not implemented | No role-based access control |
| **HTTPS** | ❌ HTTP only | LocalDB environment |
| **Input Validation** | ✅ Basic | Server-side validation exists |
| **SQL Injection** | ✅ Protected | Parameterized queries via EF Core |
| **XSS Protection** | ✅ Protected | React auto-escapes output |
| **CORS** | ✅ Configured | Localhost origins only |

### Maintainability

| Factor | Rating | Evidence |
|--------|--------|----------|
| **Code Structure** | Good | Clear layering, separation of concerns |
| **Documentation** | Excellent | Comprehensive reference docs |
| **Naming Conventions** | Good | Consistent, self-documenting |
| **Code Comments** | Adequate | Focus on "why", not "what" |
| **Testing** | ⚠️ Minimal | Manual testing only, no unit tests |

### Reliability

| Metric | Current | Target |
|--------|---------|--------|
| **Uptime** | No SLA | 99.9% (production) |
| **Error Rate** | Unknown | <1% |
| **MTTR (Mean Time to Recovery)** | N/A | <1 hour |
| **Data Backup** | ❌ None | Daily automated |

---

## Technology Decisions

### Frontend Framework: React

**Decision:** Use React 18 with TypeScript

**Rationale:**
- Large ecosystem and community support
- Component-based architecture promotes reusability
- Excellent developer tooling (DevTools, IDE extensions)
- TypeScript integration provides type safety
- Hiring pool: Easier to find React developers

**Alternatives Considered:**
- **Angular:** More opinionated, steeper learning curve
- **Vue.js:** Smaller ecosystem, less enterprise adoption
- **Svelte:** Newer, less mature ecosystem

### Build Tool: Vite

**Decision:** Use Vite instead of Create React App

**Rationale:**
- Faster development server (instant HMR)
- Optimized production builds (Rollup)
- Native ES modules support
- Better TypeScript experience
- CRA is deprecated (no longer recommended by React team)

### Backend Framework: ASP.NET Core 8.0

**Decision:** Use ASP.NET Core Web API

**Rationale:**
- Excellent performance (benchmarks competitive with Node.js)
- Strong typing with C# reduces runtime errors
- Mature ecosystem (EF Core, Identity, SignalR)
- Built-in dependency injection
- Great Azure integration
- Team expertise

**Alternatives Considered:**
- **Node.js + Express:** Less type safety, callback hell risks
- **Spring Boot (Java):** More verbose, slower development
- **FastAPI (Python):** Less mature for enterprise workloads

### Database: SQL Server

**Decision:** Use SQL Server with SSDT

**Rationale:**
- Proven relational database for structured data
- SSDT provides enterprise-grade schema management
- Azure SQL Database compatibility
- Strong ACID guarantees
- Team expertise

**Alternatives Considered:**
- **PostgreSQL:** Good alternative, but less Azure integration
- **MongoDB:** NoSQL doesn't fit relational data model
- **SQLite:** Not suitable for production workloads

---

## Integration Points

### Frontend ↔ Backend

**Protocol:** REST API over HTTP  
**Format:** JSON  
**Authentication:** None (POC - placeholder user)  
**Base URL:** `http://localhost:5115`

**Request Flow:**
1. User interacts with React component
2. Component calls service function (e.g., `coursesService.getAll()`)
3. Axios HTTP client sends GET request to `/api/courses`
4. Backend API processes request and returns JSON
5. Frontend updates state and re-renders

**Error Handling:**
- Axios interceptors catch HTTP errors
- 4xx errors: Show user-friendly messages
- 5xx errors: Show generic error message, log to console
- Network errors: Show "Unable to connect" message

### Backend ↔ Database

**Protocol:** SQL/TDS (Tabular Data Stream)  
**ORM:** Entity Framework Core 8.0  
**Connection String:** Integrated Security (Windows Auth)

**Data Flow:**
1. Controller calls service method
2. Service calls repository method
3. Repository uses EF Core DbContext
4. EF Core generates SQL query
5. SQL Server executes query and returns results
6. EF Core materializes objects
7. Results returned through layers

**Schema Management:**
- SSDT project defines schema (DDL)
- DACPAC deployed to LocalDB
- EF Core entities must match schema
- No EF migrations (DML only pattern - see ADR-001)

---

## Deployment Model (Current)

### Local Development

```
Developer Workstation (Windows)
├── Frontend (Port 5174)
│   └── Vite dev server (npm run dev)
├── Backend (Port 5115)
│   └── Kestrel web server (dotnet run)
└── Database (LocalDB instance)
    └── (localdb)\MSSQLLocalDB
        └── Database: POC_SpecKit1Local
```

**Startup Sequence:**
1. Start database (LocalDB auto-starts on connection)
2. Start backend API (`dotnet run` in TrainingTracker.Api folder)
3. Start frontend (`npm run dev` in training-tracker-ui folder)
4. Open browser to `http://localhost:5174`

**Environment Files:**
- Backend: `appsettings.Development.json`
- Frontend: `.env`

---

## Observability

### Logging

**Backend:**
- Built-in `ILogger<T>` interface
- Console output in development
- Structured logging with severity levels
- Correlation IDs for request tracing

**Frontend:**
- `console.log()` / `console.error()` for development
- No production logging infrastructure yet

### Health Checks

**Endpoints:**
- `GET /health` - Basic liveness check (always returns 200 OK)
- `GET /health/ready` - Readiness check (includes DB connectivity)

**Response Example:**
```json
{
  "status": "ok",
  "version": "1.0.0",
  "timestampUtc": "2025-10-09T15:30:00Z",
  "uptimeSeconds": 3600
}
```

### Monitoring

**Current:** None (local development only)

**Future:** Application Insights, Log Analytics, custom dashboards

---

## Trade-offs and Limitations

### What We Sacrificed for Speed

| Feature | POC Status | Enterprise Need |
|---------|------------|-----------------|
| **Authentication** | Placeholder | Azure AD + MFA |
| **Unit Tests** | None | 80% coverage |
| **Integration Tests** | None | Critical paths |
| **Caching** | None | Redis + CDN |
| **Error Monitoring** | Console logs | Application Insights |
| **CI/CD** | None | Azure Pipelines |
| **HTTPS** | HTTP only | Required |
| **Rate Limiting** | None | API Management |

### Technical Debt

1. **No test coverage** - Makes refactoring risky
2. **Simplified authentication** - Security risk in production
3. **No caching** - Performance bottleneck at scale
4. **Manual deployment** - Error-prone, time-consuming
5. **No monitoring** - Cannot detect production issues
6. **LocalDB only** - Not production-ready
7. **No backup/recovery** - Data loss risk

---

## References

- [Frontend Architecture](./02-frontend-architecture.md)
- [Backend Architecture](./03-backend-architecture.md)
- [Data Architecture](./04-data-architecture.md)
- [API Reference](../../API_REFERENCE.md)
- [ADR-001: Persistence Strategy](../../ADR-001_Persistence_Strategy.md)

---

**Next:** [Frontend Architecture →](./02-frontend-architecture.md)
