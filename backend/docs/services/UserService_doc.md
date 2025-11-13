# Service: UserService

## Metadata

**Component Type**: Service  
**Repository**: training-tracker-api  
**File Path**: `TrainingTracker.Api/Domain/Services/IUserService.cs`  
**Last Updated**: 2025-11-12  
**Tags**: #user-management #user-profile #data-validation #service #core-feature

---

**Namespace/Project**: TrainingTracker.Api.Domain.Services  
**File Location**: `TrainingTracker.Api/Domain/Services/IUserService.cs`  
**Last Updated**: 2025-11-12  
**Complexity**: Simple  
**Documentation Level**: 🔶 Baseline (70% complete)

---

## Quick Reference (TL;DR)

**What it does:**  
🤖 Manages user CRUD operations including email uniqueness validation and full name parsing.  
❓ [HUMAN: Add business value - Provides centralized user account management for the training tracker system. Used by administrators to manage employee accounts and by users to update their profiles.]

**When to use it:**  
❓ [HUMAN: What scenarios trigger use of this service? Examples: User registration during onboarding, profile updates by users, admin user management, bulk user imports from HR systems.]

**Watch out for:**  
🤖 Email uniqueness is enforced - duplicate emails will throw `InvalidOperationException`.  
❓ [HUMAN: Add critical gotcha - Full name parsing is simplistic (splits on first space), so names with multiple parts may not parse correctly. Consider validation rules for name format.]

---

## What & Why

### Purpose

🤖 The `UserService` provides business logic for managing user accounts, including creating, reading, updating, and deleting users. It enforces email uniqueness validation and handles full name parsing into first and last name components.

❓ [HUMAN: Business purpose - This service centralizes user account management to ensure consistent validation and data integrity across the training tracker system. It supports both self-service profile management and administrative user operations. Critical for maintaining accurate employee records and enabling course enrollment tracking.]

### Capabilities

🤖 
- List users with pagination support
- Retrieve user details by ID
- Create new user accounts with email uniqueness validation
- Update existing user information with email uniqueness validation
- Delete user accounts (soft or hard delete - ❓ implementation not visible)
- Parse full name into first and last name components
- Map domain entities to DTOs for API responses

### Not Responsible For

🤖 
- Password management and hashing (not implemented in current code)
- User authentication and session management (handled elsewhere)
- User authorization and role management (not visible in current implementation)
- Email notifications about account changes (no email service dependency)
- Audit logging of user changes (no audit service dependency)

❓ [HUMAN: Clarify scope boundaries - Does NOT handle integration with external identity providers (LDAP, Active Directory, SSO). Does NOT validate email addresses beyond format (no email verification sent). Does NOT enforce password policies.]

---

## How It Works

### Primary Operation: CreateAsync

**Purpose:**  
🤖 Creates a new user account after validating email uniqueness and parsing the full name into first and last name components.  
❓ [HUMAN: Business context - Used during employee onboarding or when administrators create accounts for new hires. Ensures each user has a unique email address to prevent login conflicts.]

**Input:**  
🤖 `CreateUserRequest request` - Contains Email, FullName, IsActive  
🤖 `CancellationToken ct` - Cancellation token for async operation

**Output:**  
🤖 `UserDetailDto` - Created user details including generated ID ⚠️ and timestamp (if CreatedUtc column exists - not documented in Users_doc.md)  
🤖 Throws `InvalidOperationException` if email already exists

**Step-by-Step Flow:**

```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Validate Email Uniqueness                            │
│  What  → 🤖 Call repository.ExistsByEmailAsync(email, null)  │
│  Why   → ❓ Prevent duplicate accounts, ensure unique login  │
│  Error → 🤖 InvalidOperationException if email exists        │
│  Impact→ ❓ User creation fails, admin must use different    │
│            email or update existing user                     │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 2: Parse Full Name                                      │
│  What  → 🤖 Split FullName on first space into first/last    │
│          firstName = first part, lastName = rest (or empty)  │
│  Why   → ❓ Database stores names separately for reporting   │
│  Error → 🤖 None (handles empty/single-word names)           │
│  Impact→ ❓ Names with multiple parts may parse incorrectly  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 3: Create User Entity                                   │
│  What  → 🤖 Instantiate new User with parsed name, email,    │
│          IsActive from request                               │
│  Why   → ❓ Prepare domain entity for persistence            │
│  Error → 🤖 None (straightforward object creation)           │
│  Impact→ ❓ N/A                                               │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 4: Persist to Database                                  │
│  What  → 🤖 Call repository.CreateAsync(user)                │
│          Repository generates ID ⚠️ (and possibly timestamp) │
│  Why   → ❓ Save user to database for future access          │
│  Error → 🤖 Database exceptions (connection, constraint)     │
│  Impact→ ❓ User creation fails, transaction may need retry  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 5: Map to DTO                                           │
│  What  → 🤖 Convert User entity to UserDetailDto             │
│          Reconstruct FullName from FirstName + LastName      │
│  Why   → ❓ Return API-friendly format to controller         │
│  Error → 🤖 None (straightforward mapping)                   │
│  Impact→ ❓ N/A                                               │
└─────────────────────────────────────────────────────────────┘
                          ↓
                      [SUCCESS]
```

**Success Path:**  
🤖 Returns `UserDetailDto` with generated ID, email, full name, and active status ⚠️ (and creation timestamp if CreatedUtc column exists). HTTP 201 Created returned to client.

**Failure Paths:**  
🤖 
- `InvalidOperationException` if email already exists → HTTP 409 Conflict
- Database exceptions during CreateAsync → HTTP 500 Internal Server Error (likely)
- Validation errors from request (handled by controller) → HTTP 400 Bad Request

❓ [HUMAN: Business implications - Email conflict means user must contact admin or use different email. Database failures may require retry or manual intervention. Name parsing issues may require admin correction after creation.]

---

### Secondary Operation: UpdateAsync

**Purpose:**  
🤖 Updates an existing user account after validating the user exists and email uniqueness (excluding current user).

**Step-by-Step Flow:**

```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Check User Exists                                    │
│  What  → 🤖 Call repository.GetAsync(id)                     │
│  Why   → ❓ Ensure user exists before attempting update      │
│  Error → 🤖 Returns null if user not found                   │
│  Impact→ ❓ Update fails with 404 Not Found                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 2: Validate Email Uniqueness (Exclude Self)             │
│  What  → 🤖 Call repository.ExistsByEmailAsync(email, id)    │
│          Check if email used by another user                 │
│  Why   → ❓ Allow user to keep same email, prevent conflicts │
│  Error → 🤖 InvalidOperationException if email taken         │
│  Impact→ ❓ Update fails, user must choose different email   │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 3: Parse Full Name                                      │
│  What  → 🤖 Split FullName on first space (same as Create)   │
│  Why   → ❓ Update database name fields                      │
│  Error → 🤖 None (handles edge cases)                        │
│  Impact→ ❓ Name parsing issues persist                      │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 4: Update Entity Fields                                 │
│  What  → 🤖 Update existing entity: FirstName, LastName,     │
│          Email, IsActive                                     │
│  Why   → ❓ Apply changes to tracked entity                  │
│  Error → 🤖 None (in-memory operation)                       │
│  Impact→ ❓ N/A                                               │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 5: Persist Changes                                      │
│  What  → 🤖 Call repository.UpdateAsync(existing)            │
│  Why   → ❓ Save changes to database                         │
│  Error → 🤖 Database exceptions, returns null on failure     │
│  Impact→ ❓ Update fails, changes lost                       │
└─────────────────────────────────────────────────────────────┘
                          ↓
                      [SUCCESS]
```

---

## Business Rules

| Rule ID | Description | Why It Exists | Since When |
|---------|-------------|---------------|------------|
| 🤖 **BR-USR-001** | Email must be unique across all users | ❓ Prevents duplicate accounts, ensures unique login identifier | ❓ |
| 🤖 **BR-USR-002** | Email uniqueness excludes current user during updates | ❓ Allows users to keep same email when updating other fields | ❓ |
| 🤖 **BR-USR-003** | Full name is split on first space into FirstName and LastName | ❓ Database stores names separately (possibly for reporting, sorting, or personalization) | ❓ |
| 🤖 **BR-USR-004** | If FullName has no spaces, entire value becomes FirstName, LastName is empty | ❓ Handles single-word names (mononyms) or incomplete input | ❓ |
| 🤖 **BR-USR-005** | FullName is trimmed and multiple spaces are removed before splitting | ❓ Normalizes input to prevent parsing errors from extra whitespace | ❓ |
| 🤖 **BR-USR-006** | IsActive flag included in create/update requests | ❓ Supports soft-delete pattern or account suspension | ❓ |

❓ [HUMAN: Add context for non-obvious rules:
- BR-USR-003: Why split names this way? Does this cause issues with hyphenated names, suffixes (Jr., III), or multi-part last names? Consider alternative: store FullName as-is and derive FirstName/LastName only for display.
- BR-USR-006: What does IsActive=false mean? Soft delete? Account suspension? Login prevented? Document the business policy.]

---

## Architecture

### Where This Fits

```
┌──────────────────────┐
│   API Layer          │  🤖 UsersController
│   (Entry Point)      │  → See API documentation for endpoint details
│                      │     GET /api/users, POST /api/users, etc.
└──────────────────────┘
           ↓
┌──────────────────────┐
│   ► THIS SERVICE ◄   │  UserService
│   (Business Logic)   │  🤖 Validates email uniqueness, parses names,
│                      │     orchestrates CRUD operations
└──────────────────────┘
           ↓
┌──────────────────────┐
│   Data Layer         │  🤖 IUserRepository (InMemoryUserRepository)
│   (Database Access)  │  → Operates on: training.Users table
└──────────────────────┘
```

### Dependencies (What This Service Needs)

| Dependency | Purpose | Failure Mode |
|------------|---------|--------------|
| 🤖 `IUserRepository` | Data access for user CRUD operations and email existence checks | ❓ CRITICAL - Service cannot function without repository. All operations blocked. |

❓ [HUMAN: Add failure handling - Should service catch repository exceptions and translate to business exceptions? Or let them bubble up to controller error handling middleware?]

### Consumers (Who Uses This Service)

| Consumer | Use Case | Impact of Failure |
|----------|----------|-------------------|
| 🤖 `UsersController` | All user management API endpoints (List, Get, Create, Update, Delete) | ❓ USER-FACING - All user management operations fail. Admin cannot manage accounts. Users cannot update profiles. |
| ❓ [HUMAN: Add other consumers] | Background jobs? Sync processes? Other services? | ❓ |

---

## Data Operations

**Purpose:** Document all database interactions for impact analysis, performance optimization, and tracing service behavior to data layer.

### Reads From

| Database Object | Purpose | Business Context | Performance Notes |
|-----------------|---------|------------------|-------------------|
| 🤖 `training.Users` (via repository.ListAsync) | 🤖 Retrieve paginated list of users (all columns) | ❓ Display users in admin interface, supports pagination for large datasets | 🤖 Query: `SELECT * FROM Users ORDER BY Id OFFSET @skip ROWS FETCH NEXT @take ROWS ONLY` ❓ Consider filtering inactive users by default? Add index on IsActive for filtering |
| 🤖 `training.Users` (via repository.GetAsync) | 🤖 Retrieve single user by ID (all columns) | ❓ Display user details, populate edit forms | 🤖 Query: `SELECT * FROM Users WHERE Id = @id` ✅ Primary key lookup - optimal performance |
| 🤖 `training.Users` (via repository.ExistsByEmailAsync) | 🤖 Check email existence (SELECT COUNT or EXISTS) | ❓ Validate email uniqueness before create/update to prevent duplicate accounts | 🤖 Query: `SELECT COUNT(*) FROM Users WHERE Email = @email AND (@excludeId IS NULL OR Id != @excludeId)` ⚠️ Add index on Email column for performance (unique index ideal) |

**Cross-Repository Reference:**  
For table schema details, see [Users Table Documentation](../../../POC_SpecKitProj/docs/tables/Users_doc.md)

---

### Writes To

| Database Object | Purpose | Business Context | Performance Notes |
|-----------------|---------|------------------|-------------------|
| 🤖 `training.Users` (via repository.CreateAsync) | 🤖 INSERT new user record (Email, FirstName, LastName, IsActive) ⚠️ Plus timestamp if CreatedUtc column exists | ❓ Create new user account during onboarding or admin-initiated account creation | 🤖 Transaction: Likely part of unit of work ❓ High volume during onboarding periods? Consider batch operations for bulk imports |
| 🤖 `training.Users` (via repository.UpdateAsync) | 🤖 UPDATE existing user (Email, FirstName, LastName, IsActive) | ❓ Update user profile information or admin-initiated changes (activation/deactivation) | 🤖 Query: `UPDATE Users SET Email=@email, FirstName=@firstName, LastName=@lastName, IsActive=@isActive WHERE Id=@id` ✅ Single-row update, good performance |
| 🤖 `training.Users` (via repository.DeleteAsync) | 🤖 DELETE user record (implementation: soft or hard delete?) | ❓ Remove user account - clarify if soft delete (IsActive=false) or hard delete (row removal) | ⚠️ UNKNOWN: Soft delete or hard delete? If hard delete, what happens to related enrollments? Cascade delete or orphaned records? |

---

### Calls (Stored Procedures / Functions)

| Database Object | Purpose | Business Context | Performance Notes |
|-----------------|---------|------------------|-------------------|
| 🤖 None detected | N/A | N/A | N/A |

❓ [HUMAN: Are there any stored procedures that should be used for user operations? Complex validation logic, audit triggers, or reporting procedures?]

---

### Side Effects

| Database Object | Trigger/Effect | Business Context | Impact |
|-----------------|----------------|------------------|--------|
| 🤖 None detected in code | N/A | N/A | N/A |

❓ [HUMAN: Expected side effects that might be missing:
- **Email notification** when account created? (None found - should there be a welcome email?)
- **Audit log entry** for user changes? (None found - compliance requirement for SOX/GDPR?)
- **Cache invalidation** if user list cached? (None found - should user list be cached and invalidated on changes?)
- **Database trigger** on Users table for audit logging? (Not visible in service code)
- **Notification to admin** on new user creation? (None found - operational requirement?)
- **External system sync** (LDAP, Active Directory, HR system)? (None found - integration requirement?)]

---

## Questions & Gaps

### AI-Flagged Questions

🤖 
- **⚠️ CRITICAL - CreatedUtc Column Discrepancy**: This service documentation references `CreatedUtc` timestamp in multiple places (UserDetailDto, repository operations), but the [Users Table Documentation](../../../POC_SpecKitProj/docs/tables/Users_doc.md) does NOT list a `CreatedUtc` column in the schema. 
  - **If the column EXISTS**: Update Users_doc.md to document it
  - **If the column does NOT exist**: This service doc was generated with incorrect assumptions
  - **Action Required**: Verify actual database schema and update documentation accordingly

- **Name parsing logic is simplistic**: `FullName.Split(' ', 2)` only splits on first space. How are these cases handled?
  - Multi-part last names: "Mary Jane Smith" → FirstName="Mary", LastName="Jane Smith" ✅
  - Hyphenated names: "Jean-Claude Van Damme" → FirstName="Jean-Claude", LastName="Van Damme" ✅
  - Suffixes: "John Smith Jr." → FirstName="John", LastName="Smith Jr." ✅
  - Single names: "Madonna" → FirstName="Madonna", LastName="" ✅
  - Empty/whitespace: Handled by Trim() and RemoveEmptyEntries ✅
  - **Question**: Is this the intended behavior? Should we validate name format or store FullName as primary field?

- **IsActive flag purpose unclear**: What does `IsActive=false` mean?
  - Soft delete (user marked for deletion but retained)?
  - Account suspension (login prevented)?
  - Enrollment restrictions (cannot enroll in courses)?
  - **Question**: Document the business policy for inactive users.

- **No audit logging**: User creation, updates, and deletions are not logged.
  - **Question**: Is this a compliance or security requirement? Should we add audit logging?

- **No email verification**: Email addresses are validated for format but not verified (no confirmation email sent).
  - **Question**: Is email verification required? Should we send confirmation emails?

- **Delete implementation unclear**: `DeleteAsync` calls repository but implementation could be soft or hard delete.
  - **Question**: Clarify if this is soft delete (set IsActive=false) or hard delete (remove from database).

- **No pagination defaults**: `ListAsync` accepts page/pageSize from controller but no service-level defaults.
  - **Question**: Should service enforce max page size to prevent performance issues?

### Human-Flagged Questions

❓ [HUMAN: Add questions you have while reviewing]

**Example:**
- ❓ Why is FullName stored in requests but split into FirstName/LastName in database? Why not store FullName as-is?
- ❓ Should we validate email format beyond the database constraint? (Current validation only in CreateUserRequest DTO)
- ❓ What happens to user enrollments when a user is deleted? Cascade delete? Orphaned records?
- ❓ Should inactive users be excluded from list results by default?
- ❓ Is there a maximum page size limit to prevent performance issues with large result sets?

### Next Steps

- [ ] ❓ Document the business policy for IsActive flag (soft delete vs. suspension vs. enrollment restriction)
- [ ] ❓ Clarify name parsing requirements with business/UX team
- [ ] ❓ Determine if audit logging is required for compliance
- [ ] ❓ Confirm delete behavior (soft vs. hard delete)
- [ ] ❓ Consider adding email verification workflow if required
- [ ] ❓ Review related services: EnrollmentService (does it check user.IsActive?), AuthenticationService

---

## Documentation Standards

### This template follows the Application Knowledge Repo (AKR) system

**For universal conventions, see**:
- [AKR_CHARTER.md](../../../charters/AKR_CHARTER.md) - Core principles, generic data types, feature tags, Git format

**For backend-specific conventions, see**:
- [AKR_CHARTER_BACKEND.md](../../../charters/AKR_CHARTER_BACKEND.md) - Service documentation standards, business rule formats

**For step-by-step documentation process, see**:
- [Backend_Service_Documentation_Developer_Guide.md](../guides/Backend_Service_Documentation_Developer_Guide.md) - How to use this template with Copilot/AI

**For tagging strategy, see**:
- [TAGGING_STRATEGY_TAXONOMY.md](../../../AKR_files/TAGGING_STRATEGY_TAXONOMY.md) - Complete tag reference
- [TAGGING_STRATEGY_OVERVIEW.md](../../../AKR_files/TAGGING_STRATEGY_OVERVIEW.md) - Tagging system overview

---

## Change History

**Service evolution is tracked in Git**, not in this document.

To see how this service evolved:
```bash
git log backend/TrainingTracker.Api/Domain/Services/IUserService.cs
git log -p backend/TrainingTracker.Api/Domain/Services/IUserService.cs
git log --grep="FN#####" docs/services/UserService_doc.md
```

**Include feature tags in commit messages**:
```bash
git commit -m "docs: update UserService - add email verification (FN#####_US#####) #user-management #email #validation"
```

---

## Maintenance Checklist

**When making code changes to this service:**

- [ ] Update this documentation if behavior changes
- [ ] Update business rules table if validation logic changes
- [ ] Update flow diagram if steps added/removed
- [ ] Update Dependencies table if new services injected
- [ ] Add to "Questions & Gaps" if introducing uncertainty
- [ ] Update tags if cross-cutting concerns added (e.g., adding caching → add #caching tag)

---

## AI Generation Instructions

🤖
- All content above marked 🤖 is generated from code analysis and conventions.
- ❓ sections require human input for business context, rationale, and history.

**AI-generated tags rationale**:
- `#user-management` - Primary feature domain (CRUD operations for users)
- `#user-profile` - Users can update their own profiles
- `#data-validation` - Email uniqueness validation, name parsing logic
- `#service` - Component type classifier
- `#core-feature` - Essential service (all other features depend on user accounts)

**Tags NOT included** (but may be added later):
- `#authentication` - Not added (no authentication logic in this service, just user data management)
- `#audit-logging` - Not added (no audit logging detected in code)
- `#email` - Not added (no email service dependency found)

---

## Template Metadata

**Template Version**: 1.0 (Lean Baseline)  
**Last Updated**: 2025-11-12  
**Maintained By**: Architecture Team  
**Part of**: Application Knowledge Repo (AKR) system

**Related Files**:
- [Backend_Service_Documentation_Developer_Guide.md](../guides/Backend_Service_Documentation_Developer_Guide.md)
- [AKR_CHARTER.md](../../../charters/AKR_CHARTER.md)
- [AKR_CHARTER_BACKEND.md](../../../charters/AKR_CHARTER_BACKEND.md)
- [TAGGING_STRATEGY_TAXONOMY.md](../../../AKR_files/TAGGING_STRATEGY_TAXONOMY.md)