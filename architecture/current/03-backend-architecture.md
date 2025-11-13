# Backend Architecture - Current POC

[← Back to Architecture Overview](../../ARCHITECTURE_CURRENT_POC.md)

---

## Overview

The Training Tracker backend is an **ASP.NET Core 8.0 Web API** following a layered architecture pattern with clear separation between Controllers, Services, Repositories, and Data Access layers. It implements RESTful conventions and leverages Entity Framework Core for data persistence.

---

## Technology Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| ASP.NET Core | 8.0 | Web framework |
| C# | 12 | Programming language |
| Entity Framework Core | 8.0 | ORM |
| SQL Server | LocalDB | Database engine |
| Swagger/OpenAPI | 3.0 | API documentation |
| System.Text.Json | Built-in | JSON serialization |

---

## Project Structure

```
backend/TrainingTracker.Api/
├── Program.cs                          # Application entry point
├── appsettings.json                    # Configuration
├── appsettings.Development.json        # Dev-specific config
├── TrainingTracker.Api.csproj         # Project file
├── TrainingTracker.Api.http           # HTTP test file
│
├── Controllers/                        # HTTP endpoints
│   ├── CoursesController.cs           # Course CRUD
│   ├── UsersController.cs             # User CRUD
│   ├── EnrollmentsController.cs       # Enrollment CRUD
│   └── AdminController.cs             # Admin operations
│
├── Contracts/                          # DTOs (Request/Response)
│   ├── Courses/
│   │   └── CourseDtos.cs              # Course DTOs
│   ├── Users/
│   │   └── UserDtos.cs                # User DTOs
│   ├── Enrollments/
│   │   └── EnrollmentDtos.cs          # Enrollment DTOs
│   └── Health/
│       └── HealthDtos.cs              # Health check DTOs
│
├── Domain/                             # Business logic & interfaces
│   ├── Entities/                      # EF Core entities
│   │   ├── User.cs
│   │   ├── Course.cs
│   │   ├── Enrollment.cs
│   │   └── EnrollmentStatus.cs
│   │
│   ├── Repositories/                  # Data access interfaces
│   │   ├── ICourseRepository.cs
│   │   ├── IUserRepository.cs
│   │   └── IEnrollmentRepository.cs
│   │
│   └── Services/                      # Business logic interfaces
│       ├── ICourseService.cs
│       ├── IUserService.cs
│       └── IEnrollmentService.cs
│
├── Infrastructure/                     # Implementation details
│   ├── Persistence/                   # EF Core implementations
│   │   ├── TrainingTrackerDbContext.cs
│   │   ├── EfCourseRepository.cs
│   │   ├── EfUserRepository.cs
│   │   ├── EfEnrollmentRepository.cs
│   │   ├── InMemoryCourseRepository.cs    # For testing
│   │   ├── InMemoryUserRepository.cs
│   │   └── InMemoryEnrollmentRepository.cs
│   │
│   └── Runtime/
│       └── StartupInfo.cs             # Application startup metadata
│
└── Middleware/                         # HTTP pipeline middleware
    ├── CorrelationIdMiddleware.cs     # Request tracing
    └── ExceptionHandlingMiddleware.cs  # Global error handling
```

---

## Layered Architecture

### Request Flow

```
HTTP Request
    │
    ▼
┌──────────────────────────────────────────────────┐
│          Middleware Pipeline                      │
│  1. Correlation ID                               │
│  2. Exception Handling                           │
│  3. CORS                                         │
│  4. Authorization (future)                       │
└────────────────────┬─────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────┐
│          Controller Layer                         │
│  • HTTP endpoint (CoursesController)             │
│  • Request validation                            │
│  • Map DTOs                                      │
│  • Call service layer                            │
└────────────────────┬─────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────┐
│          Service Layer                            │
│  • Business logic (CourseService)                │
│  • Validation rules                              │
│  • Orchestrate repository calls                  │
│  • Map entities ↔ DTOs                           │
└────────────────────┬─────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────┐
│          Repository Layer                         │
│  • Data access (EfCourseRepository)              │
│  • CRUD operations                               │
│  • Query logic                                   │
│  • EF Core DbContext                             │
└────────────────────┬─────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────┐
│          Database (SQL Server LocalDB)            │
│  • training.Courses                              │
│  • training.Users                                │
│  • training.Enrollments                          │
└──────────────────────────────────────────────────┘
```

---

## Program.cs - Application Startup

### Service Registration

```csharp
var builder = WebApplication.CreateBuilder(args);

// Core services
builder.Services.AddSingleton<StartupInfo>();
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddHealthChecks();

// CORS for local development
builder.Services.AddCors(options =>
{
    options.AddPolicy("LocalDev", policy =>
    {
        policy.WithOrigins(
                  "http://localhost:5173",
                  "http://localhost:5174")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// Persistence mode toggle (InMemory vs EF)
var persistenceMode = builder.Configuration.GetValue<string>("Persistence:Mode") ?? "InMemory";

if (string.Equals(persistenceMode, "Ef", StringComparison.OrdinalIgnoreCase))
{
    var connString = builder.Configuration.GetConnectionString("TrainingTracker");
    
    builder.Services.AddDbContext<TrainingTrackerDbContext>(opts =>
    {
        opts.UseSqlServer(connString, o => o.EnableRetryOnFailure());
    });
    
    builder.Services.AddScoped<ICourseRepository, EfCourseRepository>();
    builder.Services.AddScoped<IUserRepository, EfUserRepository>();
    builder.Services.AddScoped<IEnrollmentRepository, EfEnrollmentRepository>();
}
else
{
    builder.Services.AddSingleton<ICourseRepository, InMemoryCourseRepository>();
    builder.Services.AddSingleton<IUserRepository, InMemoryUserRepository>();
    builder.Services.AddSingleton<IEnrollmentRepository, InMemoryEnrollmentRepository>();
}

// Service layer
builder.Services.AddScoped<ICourseService, CourseService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IEnrollmentService, EnrollmentService>();
```

### Middleware Pipeline

```csharp
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Custom middleware (ORDER MATTERS!)
app.UseCorrelationId();           // 1. Add correlation ID to requests
app.UseGlobalExceptionHandling(); // 2. Catch unhandled exceptions
app.UseCors("LocalDev");          // 3. Enable CORS
app.UseAuthorization();           // 4. Authorization (future)

app.MapControllers();             // 5. Route to controllers

// Health check endpoints
app.MapGet("/health", ...);       // Liveness probe
app.MapGet("/health/ready", ...); // Readiness probe

app.Run();
```

---

## Controllers

### Pattern: Thin Controllers

Controllers handle HTTP concerns only:
- Route definition
- Request/response mapping
- HTTP status codes
- Input validation

**Business logic belongs in Services!**

### Example: CoursesController

```csharp
[ApiController]
[Route("api/[controller]")]
public class CoursesController : ControllerBase
{
    private readonly ICourseService _courseService;

    public CoursesController(ICourseService courseService)
    {
        _courseService = courseService;
    }

    [HttpGet]
    public async Task<IActionResult> GetCourses(
        [FromQuery] int page = 1, 
        [FromQuery] int pageSize = 20)
    {
        var result = await _courseService.GetPagedAsync(page, pageSize);
        return Ok(result);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetCourse(Guid id)
    {
        var course = await _courseService.GetByIdAsync(id);
        if (course == null)
            return NotFound(new { message = $"Course with ID {id} not found" });
            
        return Ok(course);
    }

    [HttpPost]
    public async Task<IActionResult> CreateCourse([FromBody] CreateCourseRequest request)
    {
        var course = await _courseService.CreateAsync(request);
        return CreatedAtAction(nameof(GetCourse), new { id = course.Id }, course);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateCourse(Guid id, [FromBody] UpdateCourseRequest request)
    {
        var course = await _courseService.UpdateAsync(id, request);
        if (course == null)
            return NotFound();
            
        return Ok(course);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteCourse(Guid id)
    {
        var success = await _courseService.DeleteAsync(id);
        if (!success)
            return NotFound();
            
        return NoContent();
    }
}
```

**HTTP Status Codes:**
- `200 OK` - Successful GET/PUT
- `201 Created` - Successful POST
- `204 No Content` - Successful DELETE
- `400 Bad Request` - Validation failure
- `404 Not Found` - Resource not found
- `409 Conflict` - Business rule violation (e.g., duplicate)
- `500 Internal Server Error` - Unhandled exception

---

## Services

### Pattern: Business Logic Layer

Services contain:
- Business rules and validation
- Orchestration of multiple repository calls
- Entity ↔ DTO mapping
- Transaction coordination (future)

### Example: CourseService

```csharp
public class CourseService : ICourseService
{
    private readonly ICourseRepository _repository;

    public CourseService(ICourseRepository repository)
    {
        _repository = repository;
    }

    public async Task<PagedResult<CourseSummaryDto>> GetPagedAsync(int page, int pageSize)
    {
        var (courses, totalCount) = await _repository.GetPagedAsync(page, pageSize);
        
        var items = courses.Select(MapSummary).ToList();
        
        return new PagedResult<CourseSummaryDto>
        {
            Items = items,
            TotalCount = totalCount,
            Page = page,
            PageSize = pageSize,
            TotalPages = (int)Math.Ceiling(totalCount / (double)pageSize)
        };
    }

    public async Task<CourseDetailDto> CreateAsync(CreateCourseRequest request)
    {
        // Business rule: Check uniqueness
        if (await _repository.ExistsByTitleAsync(request.Title))
        {
            throw new InvalidOperationException($"Course with title '{request.Title}' already exists");
        }

        var course = new Course
        {
            Id = Guid.NewGuid(),
            Title = request.Title,
            Category = request.Category,
            Description = request.Description,
            ValidityMonths = request.ValidityMonths,
            IsRequired = request.IsRequired,
            IsActive = request.IsActive,
            CreatedUtc = DateTime.UtcNow
        };

        await _repository.CreateAsync(course);
        return MapDetail(course);
    }

    private static CourseSummaryDto MapSummary(Course course) => new()
    {
        CourseId = course.Id,
        Title = course.Title,
        Category = course.Category,
        ValidityMonths = course.ValidityMonths,
        IsRequired = course.IsRequired,
        IsActive = course.IsActive
    };

    private static CourseDetailDto MapDetail(Course course) => new()
    {
        CourseId = course.Id,
        Title = course.Title,
        Category = course.Category,
        Description = course.Description,
        ValidityMonths = course.ValidityMonths,
        IsRequired = course.IsRequired,
        IsActive = course.IsActive,
        CreatedUtc = course.CreatedUtc,
        UpdatedUtc = course.UpdatedUtc
    };
}
```

---

## Repositories

### Pattern: Data Access Abstraction

Repositories:
- Implement CRUD operations
- Encapsulate EF Core queries
- Return domain entities (not DTOs)
- Abstract away database details

### Interface Example

```csharp
public interface ICourseRepository
{
    Task<(IEnumerable<Course> courses, int totalCount)> GetPagedAsync(int page, int pageSize);
    Task<Course?> GetByIdAsync(Guid id);
    Task<bool> ExistsByTitleAsync(string title, Guid? excludeId = null);
    Task CreateAsync(Course course);
    Task UpdateAsync(Course course);
    Task DeleteAsync(Guid id);
}
```

### EF Core Implementation

```csharp
public class EfCourseRepository : ICourseRepository
{
    private readonly TrainingTrackerDbContext _context;

    public EfCourseRepository(TrainingTrackerDbContext context)
    {
        _context = context;
    }

    public async Task<(IEnumerable<Course> courses, int totalCount)> GetPagedAsync(int page, int pageSize)
    {
        var query = _context.Courses
            .Where(c => c.IsPublished) // Business filter
            .OrderBy(c => c.Title);
            
        var totalCount = await query.CountAsync();
        
        var courses = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
            
        return (courses, totalCount);
    }

    public async Task<Course?> GetByIdAsync(Guid id)
    {
        return await _context.Courses.FindAsync(id);
    }

    public async Task<bool> ExistsByTitleAsync(string title, Guid? excludeId = null)
    {
        var query = _context.Courses.Where(c => c.Title == title);
        
        if (excludeId.HasValue)
            query = query.Where(c => c.Id != excludeId.Value);
            
        return await query.AnyAsync();
    }

    public async Task CreateAsync(Course course)
    {
        _context.Courses.Add(course);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Course course)
    {
        _context.Courses.Update(course);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Guid id)
    {
        var course = await GetByIdAsync(id);
        if (course != null)
        {
            _context.Courses.Remove(course);
            await _context.SaveChangesAsync();
        }
    }
}
```

---

## Entity Framework Core

### DbContext Configuration

```csharp
public class TrainingTrackerDbContext : DbContext
{
    public TrainingTrackerDbContext(DbContextOptions<TrainingTrackerDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Course> Courses => Set<Course>();
    public DbSet<Enrollment> Enrollments => Set<Enrollment>();
    public DbSet<EnrollmentStatus> EnrollmentStatuses => Set<EnrollmentStatus>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Map to SSDT-managed schema
        modelBuilder.Entity<User>().ToTable("Users", "training");
        modelBuilder.Entity<Course>().ToTable("Courses", "training");
        modelBuilder.Entity<Enrollment>().ToTable("Enrollments", "training");
        modelBuilder.Entity<EnrollmentStatus>().ToTable("EnrollmentStatus", "training");

        // Configure relationships
        modelBuilder.Entity<Enrollment>()
            .HasOne<User>()
            .WithMany()
            .HasForeignKey(e => e.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Enrollment>()
            .HasOne<Course>()
            .WithMany()
            .HasForeignKey(e => e.CourseId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
```

### Entity Example

```csharp
public class Course
{
    public Guid Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Category { get; set; }
    public string? Description { get; set; }
    public int? ValidityMonths { get; set; }
    public bool IsRequired { get; set; }
    public bool IsActive { get; set; }
    public bool IsPublished { get; set; }
    public DateTime CreatedUtc { get; set; }
    public DateTime? UpdatedUtc { get; set; }
}
```

**Important:** Entities must match SSDT schema (no migrations)

---

## Middleware

### 1. Correlation ID Middleware

**Purpose:** Add unique ID to each request for tracing

```csharp
public class CorrelationIdMiddleware
{
    public const string HeaderName = "X-Correlation-Id";
    private readonly RequestDelegate _next;

    public CorrelationIdMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var correlationId = context.Request.Headers[HeaderName].FirstOrDefault()
                          ?? Guid.NewGuid().ToString();
        
        context.Items[HeaderName] = correlationId;
        context.Response.Headers[HeaderName] = correlationId;
        
        await _next(context);
    }
}
```

**Usage:** `app.UseCorrelationId();`

### 2. Exception Handling Middleware

**Purpose:** Catch unhandled exceptions, return consistent error format

```csharp
public class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlingMiddleware> _logger;

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (InvalidOperationException ex)
        {
            // Business rule violations → 409 Conflict
            await HandleExceptionAsync(context, ex, StatusCodes.Status409Conflict);
        }
        catch (Exception ex)
        {
            // Unhandled exceptions → 500 Internal Server Error
            _logger.LogError(ex, "Unhandled exception");
            await HandleExceptionAsync(context, ex, StatusCodes.Status500InternalServerError);
        }
    }

    private static async Task HandleExceptionAsync(HttpContext context, Exception ex, int statusCode)
    {
        context.Response.StatusCode = statusCode;
        context.Response.ContentType = "application/json";
        
        var correlationId = context.Items[CorrelationIdMiddleware.HeaderName];
        
        var response = new
        {
            message = ex.Message,
            traceId = correlationId,
            timestamp = DateTime.UtcNow
        };
        
        await context.Response.WriteAsJsonAsync(response);
    }
}
```

**Usage:** `app.UseGlobalExceptionHandling();`

---

## Configuration Management

### appsettings.json

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

### appsettings.Development.json

```json
{
  "Persistence": {
    "Mode": "Ef"
  },
  "ConnectionStrings": {
    "TrainingTracker": "Server=(localdb)\\MSSQLLocalDB;Database=POC_SpecKit1Local;Integrated Security=True;TrustServerCertificate=True;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "Microsoft.AspNetCore": "Information"
    }
  }
}
```

**Access in Code:**
```csharp
var mode = builder.Configuration.GetValue<string>("Persistence:Mode");
var connString = builder.Configuration.GetConnectionString("TrainingTracker");
```

---

## Dependency Injection

### Service Lifetimes

| Lifetime | Usage | Example |
|----------|-------|---------|
| **Transient** | New instance per request | Lightweight, stateless services |
| **Scoped** | One instance per HTTP request | DbContext, repositories, services |
| **Singleton** | One instance for app lifetime | Configuration, caching, startup info |

### Registration Examples

```csharp
// Scoped: New instance per request
builder.Services.AddScoped<ICourseService, CourseService>();
builder.Services.AddScoped<ICourseRepository, EfCourseRepository>();

// Singleton: One instance forever
builder.Services.AddSingleton<StartupInfo>();

// Transient: New instance every time
builder.Services.AddTransient<IEmailService, EmailService>();
```

---

## API Documentation (Swagger)

### Configuration

```csharp
builder.Services.AddOpenApi();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}
```

**Access:** http://localhost:5115/swagger

**Benefits:**
- Interactive API testing
- Auto-generated documentation
- Client code generation (future)

---

## Known Limitations

1. **No Unit Tests:** Service/repository logic not tested
2. **No Integration Tests:** HTTP endpoints not tested
3. **No Logging Framework:** Using built-in `ILogger` only
4. **No Caching:** Every request hits database
5. **No Rate Limiting:** API can be overwhelmed
6. **No Authentication:** Endpoints publicly accessible
7. **No Input Sanitization:** Beyond basic validation
8. **No Transaction Management:** Multi-step operations not atomic
9. **No Background Jobs:** No scheduled tasks or queues
10. **No API Versioning:** Breaking changes will break clients

---

## References

- [Frontend Architecture](./02-frontend-architecture.md)
- [Data Architecture](./04-data-architecture.md)
- [API Reference](../../API_REFERENCE.md)
- [ADR-001: Persistence Strategy](../../ADR-001_Persistence_Strategy.md)

---

**Next:** [Data Architecture →](./04-data-architecture.md)
