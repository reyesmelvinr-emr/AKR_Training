# API: Users Controller

## Metadata

**Component Type**: API Controller  
**Repository**: training-tracker-api  
**File Path**: `TrainingTracker.Api/Controllers/UsersController.cs`  
**Last Updated**: 2025-11-12  
**Tags**: #user-management #user-profile #api #rest #core-feature

---

**Route Prefix**: `/api/users`  
**Controller**: `UsersController`  
**Namespace**: `TrainingTracker.Api.Controllers`  
**Authentication**: ❓ [HUMAN: Add authentication requirements - Anonymous? JWT Bearer? API Key?]  
**Authorization**: ❓ [HUMAN: Add authorization requirements - Admin only? User can manage own profile?]

---

## Overview

🤖 REST API controller providing HTTP endpoints for user management operations including listing, retrieving, creating, updating, and deleting user accounts.

❓ [HUMAN: Business context - Primary interface for admin user management and self-service profile updates. Used by admin dashboard for user administration and by user profile pages for self-service updates.]

---

## Endpoints

### 1. List Users (Paginated)

**HTTP Method**: `GET`  
**Route**: `/api/users`  
**Query Parameters**:
- `page` (int, optional, default: 1) - Page number for pagination
- `pageSize` (int, optional, default: 10) - Number of items per page

**Request Example**:
```http
GET /api/users?page=1&pageSize=20 HTTP/1.1
Host: localhost:5000
```

**Success Response** (200 OK):
```json
{
  "items": [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "email": "alice@example.com",
      "fullName": "Alice Example",
      "isActive": true,
      "createdUtc": "2025-11-12T10:30:00Z"
    }
  ],
  "page": 1,
  "pageSize": 20,
  "totalCount": 45
}
```

**Response Type**: `PagedResponse<UserSummaryDto>`

**Business Logic**: 🤖 Calls `UserService.ListAsync()` to retrieve paginated list of users.

**Use Cases**:
- ❓ Admin viewing all user accounts
- ❓ User search/filtering (if implemented)
- ❓ Bulk operations setup

---

### 2. Get User by ID

**HTTP Method**: `GET`  
**Route**: `/api/users/{id}`  
**Path Parameters**:
- `id` (guid, required) - Unique user identifier

**Request Example**:
```http
GET /api/users/3fa85f64-5717-4562-b3fc-2c963f66afa6 HTTP/1.1
Host: localhost:5000
```

**Success Response** (200 OK):
```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "email": "alice@example.com",
  "fullName": "Alice Example",
  "isActive": true,
  "createdUtc": "2025-11-12T10:30:00Z"
}
```

**Error Response** (404 Not Found):
```json
{
  "traceId": "00-abc123...",
  "message": "User not found"
}
```

**Response Type**: `UserDetailDto`

**Business Logic**: 🤖 Calls `UserService.GetAsync()` to retrieve user details by ID.

**Use Cases**:
- ❓ View user profile details
- ❓ Load user data for editing
- ❓ Verify user exists before operations

---

### 3. Create User

**HTTP Method**: `POST`  
**Route**: `/api/users`  
**Request Body**: `CreateUserRequest`

**Request Example**:
```http
POST /api/users HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "email": "bob@example.com",
  "fullName": "Bob Smith",
  "isActive": true
}
```

**Success Response** (201 Created):
```json
{
  "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "email": "bob@example.com",
  "fullName": "Bob Smith",
  "isActive": true,
  "createdUtc": "2025-11-12T14:25:00Z"
}
```

**Response Headers**:
```
Location: /api/users/7c9e6679-7425-40de-944b-e07fc1f90ae7
```

**Error Response** (400 Bad Request):
```json
{
  "errors": {
    "Email": ["Email is required", "Invalid email format"],
    "FullName": ["Full name is required"]
  }
}
```

**Error Response** (409 Conflict):
```json
{
  "traceId": "00-abc123...",
  "message": "A user with the email 'bob@example.com' already exists."
}
```

**Response Type**: `UserDetailDto`

**Business Logic**: 
- 🤖 Validates request using model validation attributes
- 🤖 Calls `UserService.CreateAsync()` 
- 🤖 Service validates email uniqueness
- 🤖 Service parses full name into first/last name
- 🤖 Returns 409 Conflict if email already exists

**Use Cases**:
- ❓ Admin creating new user accounts
- ❓ User self-registration (if enabled)
- ❓ Bulk user import from HR system

**Validation Rules**:
- `Email`: Required, must be valid email format, max 256 characters
- `FullName`: Required, 1-128 characters
- `IsActive`: Optional, defaults to `true`

---

### 4. Update User

**HTTP Method**: `PUT`  
**Route**: `/api/users/{id}`  
**Path Parameters**:
- `id` (guid, required) - Unique user identifier to update

**Request Body**: `UpdateUserRequest`

**Request Example**:
```http
PUT /api/users/3fa85f64-5717-4562-b3fc-2c963f66afa6 HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "email": "alice.updated@example.com",
  "fullName": "Alice Updated Example",
  "isActive": false
}
```

**Success Response** (200 OK):
```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "email": "alice.updated@example.com",
  "fullName": "Alice Updated Example",
  "isActive": false,
  "createdUtc": "2025-11-12T10:30:00Z"
}
```

**Error Response** (404 Not Found):
```json
{
  "traceId": "00-abc123...",
  "message": "User not found"
}
```

**Error Response** (409 Conflict):
```json
{
  "traceId": "00-abc123...",
  "message": "A user with the email 'alice.updated@example.com' already exists."
}
```

**Response Type**: `UserDetailDto`

**Business Logic**: 
- 🤖 Validates request using model validation attributes
- 🤖 Calls `UserService.UpdateAsync()`
- 🤖 Service checks if user exists (404 if not found)
- 🤖 Service validates email uniqueness excluding current user
- 🤖 Service parses full name into first/last name
- 🤖 Returns 409 Conflict if email used by another user

**Use Cases**:
- ❓ User updating own profile
- ❓ Admin updating user information
- ❓ Deactivating user accounts (IsActive = false)

**Validation Rules**:
- `Email`: Required, must be valid email format, max 256 characters
- `FullName`: Required, 1-128 characters
- `IsActive`: Required

---

### 5. Delete User

**HTTP Method**: `DELETE`  
**Route**: `/api/users/{id}`  
**Path Parameters**:
- `id` (guid, required) - Unique user identifier to delete

**Request Example**:
```http
DELETE /api/users/3fa85f64-5717-4562-b3fc-2c963f66afa6 HTTP/1.1
Host: localhost:5000
```

**Success Response** (204 No Content):
```
(Empty response body)
```

**Error Response** (404 Not Found):
```json
{
  "traceId": "00-abc123...",
  "message": "User not found"
}
```

**Business Logic**: 
- 🤖 Calls `UserService.DeleteAsync()`
- 🤖 Returns 204 No Content on success
- 🤖 Returns 404 Not Found if user doesn't exist

**Use Cases**:
- ❓ Admin permanently removing user accounts
- ❓ User account self-deletion (if enabled)
- ❓ Cleanup of test/duplicate accounts

**Important Questions**:
- ❓ Is this a soft delete (sets IsActive=false) or hard delete (removes from database)?
- ❓ What happens to user's enrollments when deleted?
- ❓ Should there be authorization checks (can only delete own account or admin only)?

---

## Common Response Codes

| Status Code | Meaning | When It Occurs |
|-------------|---------|----------------|
| 200 OK | Success | GET (single), PUT operations successful |
| 201 Created | Resource created | POST operation successful |
| 204 No Content | Success, no body | DELETE operation successful |
| 400 Bad Request | Validation error | Request body validation fails |
| 404 Not Found | Resource not found | User ID doesn't exist |
| 409 Conflict | Business rule violation | Email uniqueness violation |
| 500 Internal Server Error | Server error | Unhandled exception (via middleware) |

---

## Error Response Format

All error responses include a `traceId` from the correlation ID middleware for troubleshooting:

```json
{
  "traceId": "00-abc123def456...",
  "message": "Human-readable error message"
}
```

**Validation errors** (400 Bad Request) follow ASP.NET Core model validation format:
```json
{
  "errors": {
    "FieldName": ["Error message 1", "Error message 2"]
  }
}
```

---

## Middleware & Cross-Cutting Concerns

### Correlation ID Middleware
🤖 Adds correlation ID to `HttpContext.Items` for request tracing. Included in error responses as `traceId`.

### Exception Handling Middleware
🤖 Catches unhandled exceptions and returns standardized error responses.

❓ [HUMAN: Add other middleware - Authentication? Authorization? Rate limiting? Request logging?]

---

## Dependencies

| Dependency | Purpose |
|------------|---------|
| 🤖 `IUserService` | Business logic for user management |
| 🤖 `ILogger<UsersController>` | Logging warnings and errors |

---

## Related Documentation

- **Service Layer**: [UserService Documentation](../services/UserService_doc.md)
- **Database Layer**: [Users Table Documentation](../../../POC_SpecKitProj/docs/tables/Users_doc.md)
- **DTOs**: `TrainingTracker.Api.Contracts.Users.*`
  - `UserSummaryDto` - List response item
  - `UserDetailDto` - Single user response
  - `CreateUserRequest` - Create request body
  - `UpdateUserRequest` - Update request body

---

## Testing

### Manual Testing

See `TrainingTracker.Api.http` for HTTP request examples.

### Automated Tests

- `UsersEndpointTests.cs` - In-memory repository tests
- `UsersEndpointEfTests.cs` - Entity Framework integration tests

---

## Security Considerations

❓ [HUMAN: Document security requirements]

**Questions to address**:
- Authentication required? What scheme (JWT, API Key, Cookie)?
- Authorization rules:
  - Can users list all users or only admins?
  - Can users view other users' details?
  - Can users update only their own profile or admin can update anyone?
  - Can users delete their own account or admin only?
- Rate limiting on create/update to prevent abuse?
- Audit logging for user changes?
- PII data protection (email, full name)?

---

## API Versioning

❓ [HUMAN: Add versioning strategy if applicable]

**Current**: No versioning (v1 implicit)

**Future considerations**:
- URL versioning: `/api/v2/users`
- Header versioning: `Accept: application/vnd.trainingtracker.v2+json`
- Query string versioning: `/api/users?api-version=2.0`

---

## Changelog

**Schema evolution is tracked in Git**, not in this document.

To see API changes:
```bash
git log backend/TrainingTracker.Api/Controllers/UsersController.cs
git log -p backend/TrainingTracker.Api/Controllers/UsersController.cs
```

---

## Documentation Standards

### This template follows the Application Knowledge Repo (AKR) system

**For universal conventions, see**:
- [AKR_CHARTER.md](../charters/AKR_CHARTER.md) - Core principles, generic data types, feature tags, Git format

**For backend-specific conventions, see**:
- [AKR_CHARTER_BACKEND.md](../charters/AKR_CHARTER_BACKEND.md) - Service documentation standards

**For tagging strategy, see**:
- [TAGGING_STRATEGY_TAXONOMY.md](../../../AKR_files/TAGGING_STRATEGY_TAXONOMY.md) - Complete tag reference

---

## Notes

⚠️ **PLACEHOLDER DOCUMENTATION**: This API documentation is a placeholder created outside the current AKR POC scope. When formal API documentation standards are established, migrate this content to the official API documentation system.

**Current Status**: 
- ✅ Endpoints documented from code analysis
- ❓ Security/authentication requirements need human input
- ❓ Business use cases need validation
- ❓ Error handling edge cases need verification

**Future Enhancements**:
- Add OpenAPI/Swagger specification
- Add API client examples (C#, JavaScript, Python)
- Add performance benchmarks
- Add caching strategy
- Add API versioning policy

---

**Document Status**: 🟡 Placeholder (Awaiting API Documentation Standards)  
**Last Updated**: 2025-11-12  
**Maintained By**: Development Team
