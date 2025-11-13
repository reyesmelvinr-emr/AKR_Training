# Service: [SERVICE_NAME]

**Namespace/Project**: [Project.Services]  
**File Location**: `src/Services/[ServiceName].cs`  
**Last Updated**: [YYYY-MM-DD]  
**Complexity**: Simple (CRUD operations)

---

## Purpose

[1-3 sentences describing what this service does and why it exists]

**Example:**
> CourseService provides basic CRUD operations for training course management. Handles course creation, updates, retrieval, and soft deletion with simple validation.

---

## Key Methods

| Method | Purpose | Returns |
|--------|---------|---------|
| `GetByIdAsync(Guid id)` | Retrieve single course by ID | Course entity or null |
| `GetAllAsync()` | Retrieve all active courses | List of courses |
| `CreateAsync(CreateCourseDto dto)` | Create new course | Created course entity |
| `UpdateAsync(Guid id, UpdateCourseDto dto)` | Update existing course | Updated course entity |
| `DeleteAsync(Guid id)` | Soft-delete course (IsActive=false) | Boolean success |

---

## Dependencies

**Required Services:**
[List injected dependencies, or "None"]

**Example:**
- `ICourseRepository` - Data access for Courses table
- `IMapper` - DTO to entity mapping

**Database Tables:**
[List tables accessed]

**Example:**
- Reads/Writes: `training.Courses`

---

## API Documentation

**REST Endpoints:** See [API Reference Database](https://api-docs.company.com/courses) for HTTP endpoint details

---

## Business Rules

[List key rules if any exist, otherwise: "None - straightforward CRUD operations"]

**Example:**
- Course title is required and must be unique
- Soft delete preserves history (IsActive=false)
- Only active courses appear in public listings

---

## Notes

[Any special considerations, gotchas, or future work]

**Example:**
- Future: Add course prerequisites validation
- Future: Add approval workflow for course creation

---

## Questions & Gaps

[List unknowns or areas needing clarification]

**Example:**
- ❓ Should deleted courses be hidden from admin panel too?
- ❓ Need validation for course duration (currently unconstrained)

---

## Documentation Standards

This template follows the **Minimal Service Documentation** approach:
- For simple CRUD services (<200 lines)
- Focuses on quick reference
- Detailed documentation in API database
- Augment with inline code comments for complex logic

See `backend_service_template_proposals.md` for template selection guidance.

---

**Template Version**: Minimal v1.0  
**Time to Complete**: 10-15 minutes  
**Best For**: Simple CRUD services, small teams, self-explanatory code
