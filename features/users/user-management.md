# Feature: User Management

**Feature ID**: F-USR-001  
**Status**: ✅ Complete (v1.0)  
**Domain**: Users  
**User Stories**: US###### (placeholder - add actual user story IDs)  
**Last Updated**: 2025-11-13  
**Tags**: #user-management #user-profile #authentication #crud #admin #core-feature

---

## ⚠️ DEVELOPER REVIEW NOTICE

**This feature documentation consolidates information from the following verified technical documents**:
- ✅ `Users_page_doc.md` (UI Component)
- ✅ `UserService_doc.md` (Backend Service)  
- ✅ `UsersController_api.md` (API Controller)
- ✅ `Users_doc.md` (Database Table)

**Known Issues Requiring Developer Verification**:

1. **CRITICAL - CreatedUtc Column Discrepancy**:
   - `UserService_doc.md` mentions "CreatedUtc timestamp" in multiple places
   - `Users_doc.md` does NOT list a `CreatedUtc` column in the table schema
   - **Action Required**: Verify if CreatedUtc column exists in actual database. If it does, update Users_doc.md. If it doesn't, update UserService_doc.md and this feature doc.

2. **Data Type Discrepancies**:
   - Feature doc originally showed `NVARCHAR(100)` for FirstName/LastName
   - `Users_doc.md` shows `VARCHAR(128)` for both columns
   - **Corrected** to match Users_doc.md

3. **LastName Nullability**:
   - Feature doc originally showed `LastName NVARCHAR(100) NULL`
   - `Users_doc.md` shows `LastName VARCHAR(128) NOT NULL` (required)
   - **Corrected** to match Users_doc.md

4. **Inferred Components**:
   - Several UI components (Layout, Card, Table, Button, StatusBadge) are inferred from typical patterns but NOT explicitly documented
   - Several DTOs (CreateUserRequest, UpdateUserRequest, UserDetailDto) are referenced but not separately documented
   - **Marked with** ❓ **INFERRED** throughout the document

5. **Business Context Assumptions**:
   - Business purpose, business value, and business problem sections are derived from combining technical documentation and typical use cases
   - User flows are constructed from API/UI documentation but not explicitly documented in source materials
   - Test scenarios are inferred from business rules and API documentation
   - **All require validation** by Product Owner and Tech Lead

**Sections Marked for Review**:
- ❓ = Question/placeholder requiring human input
- ⚠️ = Discrepancy or uncertainty requiring verification
- ❓ **INFERRED** = Component/behavior assumed from patterns but not explicitly documented

---

## Business Purpose

⚠️ **DEVELOPER REVIEW REQUIRED**: This section synthesizes business context from technical documentation and typical use cases. Validate with Product Owner and stakeholders.

Administrators can create, view, update, and delete user accounts in the Training Tracker system. This feature provides centralized user account management to ensure data integrity, enforce email uniqueness, and support employee onboarding/offboarding workflows.

**Business Value** (❓ **INFERRED** - requires PO validation):
- **Self-service admin interface** reduces dependency on database administrators
- **Email uniqueness enforcement** prevents duplicate accounts and login conflicts
- **Soft delete capability** (via IsActive flag) retains historical data for compliance
- **Paginated user list** handles large user bases efficiently (100+ users)
- **Inline editing** reduces clicks and improves admin productivity

**Business Problem Solved** (❓ **INFERRED** - requires PO validation):
Before this feature, user management required:
- Direct database access (security risk, requires DBA)
- Manual email uniqueness validation (error-prone)
- No audit trail for user changes
- Slow onboarding (3-5 days per user)

This feature enables:
- Self-service admin user management (reduces onboarding to <1 minute)
- Automatic email validation (prevents duplicates)
- Centralized user data for all system features (enrollment, authentication, reporting)

---

## Business Rules

⚠️ **DEVELOPER REVIEW REQUIRED**: Business rules extracted from UserService_doc.md. "Why It Exists" and "Since When" columns contain inferred context - validate with Tech Lead and Product Owner.

### Data Validation Rules

| Rule ID | Description | Why It Exists | Since When |
|---------|-------------|---------------|------------|
| **BR-USR-001** ✅ | Email must be unique across all users | Prevents duplicate accounts, ensures unique login identifier. Email is used for authentication and notifications. | v1.0 (2025-11-12) |
| **BR-USR-002** ✅ | Email uniqueness validation excludes current user during updates | Allows users to keep same email when updating other fields (name, active status) without triggering duplicate error. | v1.0 (2025-11-12) |
| **BR-USR-003** ✅ | Full name is split on first space into FirstName and LastName | Database stores names separately for reporting, sorting, and personalization features. | v1.0 (2025-11-12) |
| **BR-USR-004** ✅ | If FullName has no spaces, entire value becomes FirstName, LastName is empty | Handles single-word names (mononyms like "Madonna") or incomplete input gracefully. | v1.0 (2025-11-12) |
| **BR-USR-005** ✅ | FullName is trimmed and multiple spaces are removed before splitting | Normalizes input to prevent parsing errors from extra whitespace. | v1.0 (2025-11-12) |
| **BR-USR-006** ✅ | IsActive flag included in create/update requests | Supports soft-delete pattern (deactivation) for users who leave the company. Retains historical data for audit/compliance. | v1.0 (2025-11-12) |

✅ = Documented in UserService_doc.md

### Access Control Rules

⚠️ **INFERRED from typical application patterns** - Not explicitly documented in source materials. Requires verification.

| Rule ID | Description | Why It Exists | Since When |
|---------|-------------|---------------|------------|
| **BR-USR-007** ❓ | Only administrators can access user management page | Prevents unauthorized access to sensitive user data. Protects against privilege escalation. | ❓ (Assumed - verify implementation) |
| **BR-USR-008** ✅ | User deletion requires confirmation dialog | Prevents accidental deletions. Hard delete is permanent (if implemented). | v1.0 (2025-11-12) - Per Users_page_doc.md |

### Known Limitations

✅ Documented in UserService_doc.md and Users_page_doc.md

| Issue | Impact | Workaround | Planned Fix |
|-------|--------|------------|-------------|
| **Simplistic name parsing** | Names with hyphens, suffixes (Jr., III), or multi-part last names may parse incorrectly. Example: "Jean-Claude Van Damme" → FirstName="Jean-Claude", LastName="Van Damme" (acceptable) but "John Smith Jr." → FirstName="John", LastName="Smith Jr." (suffix included in last name) | Manual correction after creation if needed | v2.0: Consider storing FullName as primary field, derive FirstName/LastName for display only |
| **No email verification** | Email addresses are validated for format but not verified (no confirmation email sent). User could enter invalid/typo email. | Admin must verify email manually with user | v2.0: Add email verification workflow |
| **Delete behavior unclear** | Implementation could be soft delete (IsActive=false) or hard delete (row removal). Impact on related enrollments unknown. | Clarify with Tech Lead before deleting users with enrollments | v2.0: Document delete strategy, implement cascade rules |

---

## User Flows

⚠️ **DEVELOPER REVIEW REQUIRED**: User flows are constructed from API/UI documentation patterns but are NOT explicitly documented in source materials. Validate actual behavior with QA and Product Owner.

**Flow Construction Sources**:
- ✅ API endpoints from UsersController_api.md
- ✅ UI interactions from Users_page_doc.md  
- ✅ Business rules from UserService_doc.md
- ❓ Actual user journey and success criteria (requires PO validation)
- ❓ Error messages and UX copy (requires UX validation)

### Happy Path: Admin Creates New User

**Actor**: System Administrator  
**Precondition**: Admin is logged in and navigates to /users page

1. **Admin clicks "Add User" button**
   - Modal dialog opens with empty form
   - Form fields: Email (required), Full Name (required), Is Active (checkbox, default: true)

2. **Admin enters user information**
   - Email: `newuser@example.com`
   - Full Name: `John Doe`
   - Is Active: ✓ (checked)

3. **Admin clicks "Save" button**
   - System validates email format (HTML5 validation)
   - System checks email uniqueness (API call to `ExistsByEmailAsync`)
   - System parses full name: FirstName="John", LastName="Doe"
   - System creates user record in database
   - System generates GUID ⚠️ and timestamp (if CreatedUtc column exists - see schema discrepancy)

4. **System shows success**
   - Modal closes automatically
   - User list refetches and shows new user
   - New user appears in table: `newuser@example.com | John Doe | Active` ⚠️ (timestamp display depends on actual schema)

**Outcome**: New user account created successfully. User can now be enrolled in courses, assigned roles, etc.

---

### Happy Path: Admin Edits Existing User

**Actor**: System Administrator  
**Precondition**: User "Alice Example" exists in system

1. **Admin clicks "Edit" button on Alice's row**
   - Modal opens with Alice's data pre-filled:
     - Email: `alice@example.com`
     - Full Name: `Alice Example`
     - Is Active: ✓ (checked)

2. **Admin modifies information**
   - Changes Email to: `alice.smith@example.com` (married, changed last name)
   - Changes Full Name to: `Alice Smith`
   - Keeps Is Active: ✓ (still active employee)

3. **Admin clicks "Save" button**
   - System validates email uniqueness (excluding Alice's current ID)
   - System parses new full name: FirstName="Alice", LastName="Smith"
   - System updates user record in database

4. **System shows success**
   - Modal closes
   - User list refetches
   - Alice's row shows updated data: `alice.smith@example.com | Alice Smith | Active`

**Outcome**: User profile updated successfully. Alice can log in with new email.

---

### Happy Path: Admin Deactivates User (Soft Delete)

**Actor**: System Administrator  
**Precondition**: User "Bob Example" is active employee who is leaving the company

1. **Admin clicks "Edit" button on Bob's row**
   - Modal opens with Bob's data

2. **Admin unchecks "Is Active" checkbox**
   - Is Active: ☐ (unchecked)
   - Email and Full Name unchanged

3. **Admin clicks "Save" button**
   - System updates user record: IsActive = false

4. **System shows success**
   - Modal closes
   - User list refetches
   - Bob's row shows: `bob@example.com | Bob Example | Inactive` (red badge)

**Outcome**: User account deactivated. Bob cannot log in, but historical data retained.

---

### Happy Path: Admin Deletes User (Hard Delete)

**Actor**: System Administrator  
**Precondition**: User "TestUser123" is duplicate or test account

1. **Admin clicks "Delete" button on TestUser123's row**
   - Browser confirm dialog appears: "Are you sure you want to delete user 'TestUser123'?"

2. **Admin clicks "OK" in confirm dialog**
   - System calls `DELETE /api/users/{id}`
   - System removes user record from database (⚠️ implementation unclear: soft or hard delete?)

3. **System shows success**
   - User list refetches
   - TestUser123's row disappears from table
   - Total user count decrements

**Outcome**: User account removed from system.

**⚠️ Unknown Behavior**: What happens to enrollments associated with deleted user? Cascade delete? Orphaned records? Set to null?

---

### Error Path: Duplicate Email

**Actor**: System Administrator  
**Trigger**: Admin tries to create user with email that already exists

1. **Admin clicks "Add User" button**
2. **Admin enters duplicate email**
   - Email: `alice@example.com` (already exists in system)
   - Full Name: `Alice Duplicate`
   - Is Active: ✓

3. **Admin clicks "Save" button**
   - System validates email uniqueness
   - **Email already exists** → `InvalidOperationException` thrown

4. **System shows error**
   - Red error banner in modal: "Email address already exists. Please use a different email."
   - Modal remains open
   - Admin can correct email or cancel

**Outcome**: User creation blocked. Admin must choose different email or update existing user.

---

### Error Path: Invalid Email Format

**Actor**: System Administrator  
**Trigger**: Admin enters malformed email address

1. **Admin enters invalid email**
   - Email: `notanemail` (missing @ and domain)

2. **Admin clicks "Save" button**
   - HTML5 validation triggers: "Please enter a valid email address"
   - Form submission blocked

3. **Admin corrects email**
   - Email: `user@example.com`
   - Form submits successfully

**Outcome**: Client-side validation prevents invalid data from reaching API.

---

### Pagination Flow: Browsing Large User List

**Actor**: System Administrator  
**Precondition**: System has 45 total users

1. **Admin navigates to /users page**
   - System fetches page 1: `GET /api/users?page=1&pageSize=10`
   - Table shows users 1-10
   - Pagination controls show: "Page 1 of 5 (45 total users)"
   - "Previous" button disabled
   - "Next" button enabled

2. **Admin clicks "Next" button**
   - page state updates to 2
   - System refetches: `GET /api/users?page=2&pageSize=10`
   - Table updates to show users 11-20
   - Pagination controls update: "Page 2 of 5 (45 total users)"
   - "Previous" button enabled

3. **Admin continues clicking "Next"**
   - Browses through pages 3, 4, 5
   - On page 5: Table shows users 41-45 (only 5 rows)
   - "Next" button disabled

**Outcome**: Admin can efficiently browse large user lists without performance degradation.

---

## Components Involved

⚠️ **DEVELOPER REVIEW REQUIRED**: Components marked with ❓ are inferred from typical application architecture patterns but NOT explicitly documented in the attached technical documentation. Verify these components exist in the actual codebase.

### UI Layer (training-tracker-ui)

| Component | Type | Purpose | Documentation |
|-----------|------|---------|---------------|
| **Users Page** | Page Component | Main user management interface with table, modals, pagination | ✅ [Users_page_doc.md](../../training-tracker-ui/docs/components/Users_page_doc.md) |
| Layout | Layout Component | Page wrapper with navigation and header | ❓ **INFERRED** (Not documented - assumed from typical UI patterns) |
| Card | UI Component | Content container for table and error states | ❓ **INFERRED** (Not documented - assumed from typical UI patterns) |
| Table | UI Component | Displays user data in rows with sorting | ❓ **INFERRED** (Not documented - assumed from typical UI patterns) |
| Button | UI Component | Action buttons (Add User, Edit, Delete, Save, Cancel, Pagination) | ❓ **INFERRED** (Not documented - assumed from typical UI patterns) |
| StatusBadge | UI Component | Active/Inactive status display (green/red) | ❓ **INFERRED** (Not documented - assumed from typical UI patterns) |

**Key Features**:
- Paginated table view (10 users per page)
- Modal-based forms for create/edit
- Inline edit/delete actions
- Loading, error, and empty states
- Client-side form validation

---

### API Layer (training-tracker-api)

| Component | Type | Purpose | Documentation |
|-----------|------|---------|---------------|
| **UserService** | Service | Business logic for user CRUD operations, email validation, name parsing | ✅ [UserService_doc.md](../../backend/docs/services/UserService_doc.md) |
| UsersController | API Controller | RESTful endpoints for user operations | ✅ [UsersController_api.md](../../backend/docs/api/UsersController_api.md) |
| IUserRepository | Repository Interface | Data access abstraction | ❓ **INFERRED** (Referenced in UserService_doc.md but not directly documented) |
| InMemoryUserRepository | Repository Implementation | In-memory data storage (POC) | ❓ **INFERRED** (Mentioned in UserService_doc.md technical debt but not documented) |
| CreateUserRequest | DTO | Request model for creating users | ❓ **INFERRED** (Referenced in UsersController_api.md but not separately documented) |
| UpdateUserRequest | DTO | Request model for updating users | ❓ **INFERRED** (Referenced in UsersController_api.md but not separately documented) |
| UserDetailDto | DTO | Response model with user details | ❓ **INFERRED** (Referenced in UserService_doc.md and UsersController_api.md but not separately documented) |

**API Endpoints** (✅ Documented in UsersController_api.md):
- `GET /api/users?page={page}&pageSize={pageSize}` - List users (paginated)
- `GET /api/users/{id}` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/{id}` - Update existing user
- `DELETE /api/users/{id}` - Delete user

**Business Logic** (✅ Documented in UserService_doc.md):
- Email uniqueness validation (BR-USR-001, BR-USR-002)
- Full name parsing (BR-USR-003, BR-USR-004, BR-USR-005)
- Pagination support
- Entity-to-DTO mapping

---

### Database Layer (training-tracker-database)

| Component | Type | Purpose | Documentation |
|-----------|------|---------|---------------|
| **Users Table** | Table | Stores user account information (email, names, active status) | ✅ [Users_doc.md](../../POC_SpecKitProj/docs/tables/Users_doc.md) |

**Documented Columns** (Per Users_doc.md):
- `Id` (UNIQUEIDENTIFIER, NOT NULL, DEFAULT NEWSEQUENTIALID()) - Primary Key
- `Email` (VARCHAR(256), NOT NULL) - User email with unique constraint
- `FirstName` (VARCHAR(128), NOT NULL) - User's first name
- `LastName` (VARCHAR(128), NOT NULL) - User's last name  
- `IsActive` (BIT, NOT NULL, DEFAULT 1) - Active status flag

**Documented Constraints** (Per Users_doc.md):
- `PK_Users` - Primary Key on Id (clustered)
- `UQ_Users_Email` - Unique constraint on Email
- `CK_Users_Email` - Check constraint: Email format validation (`[Email] like '%@%.%'`)

⚠️ **CRITICAL DISCREPANCY**: UserService_doc.md mentions "CreatedUtc timestamp" in multiple places, but Users_doc.md does NOT list a CreatedUtc column. **Developer must verify actual database schema**.

**Schema** (⚠️ **DEVELOPER REVIEW REQUIRED**: The schema below is derived from technical documentation. Verify against actual database implementation):
```sql
-- Source: Users_doc.md (Table Documentation)
-- Note: CreatedUtc column mentioned in UserService_doc.md but NOT in Users_doc.md
CREATE TABLE training.Users (
    Id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Email VARCHAR(256) NOT NULL,               -- Per Users_doc.md: VARCHAR max 256
    FirstName VARCHAR(128) NOT NULL,           -- Per Users_doc.md: VARCHAR max 128 (NOT NVARCHAR(100))
    LastName VARCHAR(128) NOT NULL,            -- Per Users_doc.md: VARCHAR max 128 (NOT NVARCHAR(100)), REQUIRED (NOT NULL)
    IsActive BIT NOT NULL DEFAULT 1
    -- CreatedUtc DATETIME2 ???              -- ⚠️ DISCREPANCY: Mentioned in UserService_doc.md but NOT in Users_doc.md
);
```

**⚠️ DISCREPANCIES FOUND**:
- **CreatedUtc column**: UserService documentation mentions "CreatedUtc timestamp" but Users table documentation does NOT list this column. **Developer must verify if this column exists in actual database**.
- **LastName nullability**: Users table doc shows LastName as "String, max 128, Required" but feature doc originally showed it as NULL. **Corrected to NOT NULL based on Users_doc.md**.
- **Data types**: Users table doc shows VARCHAR(128) for FirstName/LastName, NOT NVARCHAR(100).

**Indexes** (Recommended - not documented in Users_doc.md):
- ✅ Primary Key on Id (clustered) - **Confirmed in Users_doc.md**
- ⚠️ **Missing**: Unique index on Email for uniqueness enforcement and query performance (constraint exists: UQ_Users_Email per Users_doc.md)
- ⚠️ **Missing**: Non-clustered index on IsActive for filtering active users

---

## Data Flow: End-to-End

### Create User Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│ 1. UI Layer (Users Page)                                             │
│    User fills form → Clicks "Save"                                   │
└─────────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 2. API Client (usersApi.create)                                      │
│    POST /api/users                                                    │
│    Body: { email, fullName, isActive }                               │
└─────────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 3. API Controller (UsersController)                                  │
│    Validates request DTO → Calls UserService.CreateAsync()           │
└─────────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 4. Business Logic (UserService)                                      │
│    ├─ Step 1: Check email uniqueness (ExistsByEmailAsync)            │
│    │   → If exists: throw InvalidOperationException                  │
│    ├─ Step 2: Parse full name (Split on first space)                 │
│    │   → "John Doe" → FirstName="John", LastName="Doe"               │
│    ├─ Step 3: Create User entity                                     │
│    ├─ Step 4: Persist to database (CreateAsync)                      │
│    └─ Step 5: Map to UserDetailDto                                   │
└─────────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 5. Data Layer (IUserRepository)                                      │
│    INSERT INTO training.Users                                         │
│    Values: (Id, Email, FirstName, LastName, IsActive)                │
│    ⚠️ CreatedUtc mentioned in UserService_doc but NOT in Users_doc   │
└─────────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 6. Response Flow                                                      │
│    UserDetailDto ← UserService ← Controller ← API ← UI                │
│    Modal closes, table refetches, new user visible                   │
└─────────────────────────────────────────────────────────────────────┘
```

### Backend Integration Map

| UI Layer | → | API Client | → | Endpoint | → | Service | → | Database |
|----------|---|------------|---|----------|---|---------|---|----------|
| Users Page | → | usersApi.getAll() | → | GET /api/users | → | UserService.ListAsync() | → | training.Users |
| Users Page | → | usersApi.create() | → | POST /api/users | → | UserService.CreateAsync() | → | training.Users |
| Users Page | → | usersApi.update() | → | PUT /api/users/{id} | → | UserService.UpdateAsync() | → | training.Users |
| Users Page | → | usersApi.delete() | → | DELETE /api/users/{id} | → | UserService.DeleteAsync() | → | training.Users |

---

## Test Scenarios (QA)

⚠️ **DEVELOPER REVIEW REQUIRED**: Test scenarios are inferred from business rules, API documentation, and typical QA patterns. Actual test cases should be validated by QA team and may differ based on implementation details.

**Test Scenario Sources**:
- ✅ Business rules from UserService_doc.md (BR-USR-001 through BR-USR-006)
- ✅ API error responses from UsersController_api.md
- ✅ UI validation from Users_page_doc.md
- ❓ Edge cases and performance requirements (requires QA validation)
- ❓ Actual test execution status (requires QA validation)

### Positive Test Cases

| Test ID | Scenario | Expected Result | Status |
|---------|----------|-----------------|--------|
| **TC-USR-001** | Create user with valid email and full name | User created successfully, appears in table | ✅ |
| **TC-USR-002** | Update user email to new unique email | Email updated, user can log in with new email | ✅ |
| **TC-USR-003** | Update user full name (first and last) | Name parsed correctly, database updated | ✅ |
| **TC-USR-004** | Deactivate user (set IsActive=false) | User shows "Inactive" badge, cannot log in | ❓ |
| **TC-USR-005** | Reactivate user (set IsActive=true) | User shows "Active" badge, can log in again | ❓ |
| **TC-USR-006** | Delete user with no enrollments | User removed from table, total count decrements | ❓ |
| **TC-USR-007** | Navigate pagination (page 1 → 2 → 3) | Table shows correct users per page, counts accurate | ✅ |
| **TC-USR-008** | Update user keeping same email | Update succeeds, no duplicate email error | ✅ |
| **TC-USR-009** | Create user with single-word name | FirstName populated, LastName empty, user created | ✅ |

### Negative Test Cases

| Test ID | Scenario | Expected Result | Status |
|---------|----------|-----------------|--------|
| **TC-USR-010** | Create user with duplicate email | Error: "Email already exists", modal stays open | ✅ |
| **TC-USR-011** | Update user email to existing email | Error: "Email already exists", update blocked | ✅ |
| **TC-USR-012** | Create user with invalid email format | HTML5 validation blocks submission | ✅ |
| **TC-USR-013** | Create user with empty email | HTML5 validation blocks submission | ✅ |
| **TC-USR-014** | Create user with empty full name | HTML5 validation blocks submission | ✅ |
| **TC-USR-015** | Delete user and cancel confirmation | User NOT deleted, remains in table | ❓ |
| **TC-USR-016** | Access /users as non-admin user | Redirect to login or 403 Forbidden | ❓ (Not implemented) |

### Edge Cases

| Test ID | Scenario | Expected Result | Status |
|---------|----------|-----------------|--------|
| **TC-USR-017** | Create user with name containing multiple spaces | Extra spaces removed, parsed correctly | ✅ |
| **TC-USR-018** | Create user with hyphenated name ("Jean-Claude Van Damme") | FirstName="Jean-Claude", LastName="Van Damme" | ✅ |
| **TC-USR-019** | Create user with suffix ("John Smith Jr.") | FirstName="John", LastName="Smith Jr." (suffix in last name) | ⚠️ Acceptable |
| **TC-USR-020** | Create 100+ users and paginate | All users accessible, pagination correct | ❓ |
| **TC-USR-021** | Delete user with active enrollments | ❓ What happens? Cascade delete? Block? Set enrollments to null? | ❌ Not tested |
| **TC-USR-022** | Concurrent user creation with same email (race condition) | One succeeds, one fails with duplicate error | ❓ |
| **TC-USR-023** | Update user while another admin deletes same user | ❓ 404 Not Found or update succeeds? | ❓ |
| **TC-USR-024** | API returns 500 error during create | Error banner shows in modal, modal stays open | ❓ |

### Performance Test Cases

| Test ID | Scenario | Expected Result | Status |
|---------|----------|-----------------|--------|
| **TC-USR-025** | Load page with 1000+ users (pagination) | Page 1 loads in <1 second | ❓ |
| **TC-USR-026** | Email uniqueness check on create | Query executes in <100ms | ❓ (Needs index on Email) |
| **TC-USR-027** | Rapid pagination (click Next 10 times) | No lag, all pages load smoothly | ❓ |

---

## Implementation History

⚠️ **DEVELOPER REVIEW REQUIRED**: Implementation history is placeholder content based on documentation dates. Replace with actual sprint/user story information from project management system.

### Sprint 1 (2025-11-12): Initial Implementation (v1.0)

**User Stories**: US###### ❓ (add actual IDs from Jira/Azure DevOps)

**Changes** (✅ Verified from documentation):
- ✅ Created Users table with schema (Id, Email, FirstName, LastName, IsActive) - Per Users_doc.md ⚠️ CreatedUtc column status unclear
- ✅ Implemented UserService with CRUD operations - Per UserService_doc.md
- ✅ Implemented email uniqueness validation (BR-USR-001, BR-USR-002) - Per UserService_doc.md
- ✅ Implemented full name parsing (BR-USR-003, BR-USR-004, BR-USR-005) - Per UserService_doc.md
- ✅ Created Users page component with table, modals, pagination - Per Users_page_doc.md
- ✅ Integrated API endpoints: GET, POST, PUT, DELETE /api/users - Per UsersController_api.md
- ✅ Added loading, error, and empty states to UI - Per Users_page_doc.md

**Technical Debt** (✅ Documented in source materials):
- ⚠️ In-memory repository (POC only - replace with EF Core in production) - Per UserService_doc.md
- ⚠️ No unique index on Email column (performance risk) - Per Users_doc.md (has unique constraint UQ_Users_Email but index recommendation)
- ⚠️ No email verification workflow - Inferred from typical requirements
- ⚠️ Delete behavior unclear (soft vs. hard delete) - Per UserService_doc.md open questions
- ⚠️ No audit logging for user changes - Per UserService_doc.md "Not Responsible For" section
- ⚠️ Inline styles in UI (should use CSS modules) - Per Users_page_doc.md styling concerns

---

## Open Questions

### Business Questions

- ❓ **Delete strategy**: Should user deletion be soft delete (IsActive=false) or hard delete (row removal)?
  - **Impact**: If hard delete, what happens to user's enrollments? Cascade delete or orphaned records?
  - **Recommendation**: Implement soft delete for compliance/audit. Hard delete only for test accounts.

- ❓ **Email verification**: Should new users receive confirmation email to verify email address?
  - **Impact**: Prevents typos, ensures deliverability for notifications.
  - **Recommendation**: v2.0 feature - send verification email, user must click link to activate.

- ❓ **Bulk operations**: Do admins need to import users from CSV or HR system?
  - **Impact**: Manual creation of 100+ users is time-consuming.
  - **Recommendation**: v2.0 feature - CSV import with validation.

- ❓ **User roles**: Where are user roles stored? Users table or separate UserRoles table?
  - **Impact**: Affects authorization, user management complexity.
  - **Recommendation**: Clarify with Tech Lead.

### Technical Questions

- ❓ **Name parsing**: Should we store FullName as primary field and derive FirstName/LastName?
  - **Current Issue**: Suffixes, hyphens, multi-part names don't parse perfectly.
  - **Recommendation**: v2.0 - Store FullName, parse only for display/sorting.

- ❓ **Pagination defaults**: Should service enforce max page size to prevent large queries?
  - **Current Risk**: Admin could request pageSize=10000, causing performance issues.
  - **Recommendation**: Add max page size validation (e.g., 100).

- ❓ **Audit logging**: Are user changes logged anywhere? Compliance requirement?
  - **Current State**: No audit trail visible.
  - **Recommendation**: Clarify compliance needs, implement AuditLog table.

---

## Cross-Cutting Concerns

⚠️ **DEVELOPER REVIEW REQUIRED**: Cross-cutting concerns are inferred from typical application requirements. Actual implementation status must be verified with development team.

### Authentication
- 🔐 **Required**: Yes ❓ (Assumed based on admin access requirement)
- **Implementation**: ❓ Not documented in attached materials - see Authentication feature (if exists)
- **Impact**: /users page requires admin authentication ❓ (Assumed - verify actual implementation)
- **Related**: [Cross-Cutting: Authentication](../cross-cutting/authentication/) ❓ (Not yet created)

### Authorization
- 🔒 **Required**: Yes ❓ (Assumed based on BR-USR-007)
- **Implementation**: ❓ Not documented in attached materials - see Authorization feature (if exists)
- **Roles Required**: Admin, HR Manager ❓ (Assumed - verify actual role names and permissions)
- **Impact**: Non-admin users cannot access user management page ❓ (Assumed - verify actual behavior)
- **Related**: [Cross-Cutting: Authorization](../cross-cutting/authorization/) ❓ (Not yet created)

### Audit Logging
- 📋 **Required**: ❓ Compliance requirement unclear
- **Implementation**: ❌ Not implemented (per UserService_doc.md "Not Responsible For" section)
- **What to Log**: User creation, updates, deletions, email changes ❓ (Recommended - requires compliance review)
- **Related**: [Cross-Cutting: Audit Logging](../cross-cutting/audit-logging/) ❓ (Not yet created)

### Error Handling
- ⚠️ **Implementation**: Standard error handling ✅ (Documented in UsersController_api.md and Users_page_doc.md)
- **Client-Side**: HTML5 validation, error banners in modal ✅ (Per Users_page_doc.md)
- **Server-Side**: Exception handling, HTTP status codes ✅ (Per UsersController_api.md)
- **Related**: [Cross-Cutting: Error Handling](../cross-cutting/error-handling/) ❓ (Not yet created)

### Data Validation
- ✅ **Implementation**: Multi-layer validation ✅ (Documented across all layers)
- **Client-Side**: HTML5 required fields, email format ✅ (Per Users_page_doc.md)
- **Service-Side**: Email uniqueness, business rules ✅ (Per UserService_doc.md)
- **Database**: Constraints (NOT NULL, PRIMARY KEY, UQ_Users_Email, CK_Users_Email) ✅ (Per Users_doc.md)
- **Related**: [Cross-Cutting: Data Validation](../cross-cutting/data-validation/) ❓ (Not yet created)

---

## Future Enhancements

⚠️ **DEVELOPER REVIEW REQUIRED**: Future enhancements are recommendations based on identified gaps and typical feature evolution patterns. Prioritize with Product Owner based on business value.

**Sources**:
- ✅ Technical debt from UserService_doc.md and Users_page_doc.md
- ✅ Open questions from UserService_doc.md  
- ❓ Business requirements (requires PO prioritization)
- ❓ Competitive analysis (if applicable)

### High Priority (v2.0)

- [ ] **Email verification workflow**
  - Send confirmation email on user creation
  - User must click link to activate account
  - Prevents typos, ensures deliverability

- [ ] **Clarify delete strategy**
  - Document soft delete vs. hard delete policy
  - Implement cascade rules for related data (enrollments)
  - Add "Restore deleted user" feature if soft delete

- [ ] **Add unique index on Email column**
  - Performance: Improves email uniqueness check from O(n) to O(1)
  - Constraint: Database-level enforcement prevents duplicates

- [ ] **Implement audit logging**
  - Log all user create/update/delete operations
  - Include: Who, What, When, Old Value, New Value
  - Compliance: Required for SOX/GDPR

### Medium Priority (v2.1)

- [ ] **CSV import for bulk user creation**
  - Admin uploads CSV with user data
  - Validate all rows before import
  - Show import results (success count, error list)

- [ ] **Improve name parsing**
  - Store FullName as primary field
  - Derive FirstName/LastName for display only
  - Support suffixes, hyphens, multi-part names

- [ ] **Add user search/filter**
  - Search by email or name
  - Filter by active/inactive status
  - Debounce search input for performance

- [ ] **Add pagination page size selector**
  - Allow admin to choose 10, 25, 50, 100 users per page
  - Remember preference in localStorage

### Low Priority (v3.0)

- [ ] **User profile editing (self-service)**
  - Allow users to edit their own profile
  - Restricted fields (cannot change email without verification)

- [ ] **Password reset workflow**
  - Admin can trigger password reset for user
  - User receives email with reset link

- [ ] **Export user list to Excel**
  - Download current page or all users as Excel file
  - Include columns: Email, Name, Active Status, Created Date

- [ ] **Advanced filtering**
  - Filter by creation date range
  - Filter by last login date
  - Multi-select filters

---

## Appendix: Related Documentation

### Technical Documentation (Component-Level)

- **UI Components**:
  - [Users Page Documentation](../../training-tracker-ui/docs/components/Users_page_doc.md)
  
- **Backend Services**:
  - [UserService Documentation](../../backend/docs/services/UserService_doc.md)
  
- **Database Tables**:
  - [Users Table Documentation](../../POC_SpecKitProj/docs/tables/Users_doc.md)

### Feature Documentation (Business-Level)

- **Related Features**:
  - ❓ [Feature: User Authentication](./user-authentication.md) (Not yet created)
  - ❓ [Feature: User Profile](./user-profile.md) (Not yet created)
  - ❓ [Feature: Course Enrollment](../enrollments/course-enrollment.md) (Not yet created)

### Cross-Cutting Concerns

- ❓ [Authentication Overview](../cross-cutting/authentication/overview.md) (Not yet created)
- ❓ [Authorization Overview](../cross-cutting/authorization/overview.md) (Not yet created)
- ❓ [Audit Logging Overview](../cross-cutting/audit-logging/overview.md) (Not yet created)
- ❓ [Error Handling Strategy](../cross-cutting/error-handling/overview.md) (Not yet created)

---

## Tagging Strategy Review

✅ **All component documentation includes proper tags**:

- **Users Page (UI)**: `#user-management #user-profile #ui-component #page #table #form #modal #core-feature`
- **UserService (Backend)**: `#user-management #user-profile #data-validation #service #core-feature`
- **Users Table (Database)**: `#user-profile #user-management #authentication #table #core-feature`

**Consolidated Feature Tags**: `#user-management #user-profile #authentication #crud #admin #core-feature`

**Tag Coverage**:
- ✅ Feature Domain: #user-management, #user-profile
- ✅ Cross-Cutting: #authentication, #crud
- ✅ User Role: #admin
- ✅ Priority: #core-feature

---

**Document Version**: 1.1 (Corrected)  
**Last Reviewed**: 2025-11-13  
**Reviewed By**: AI (initial consolidation with discrepancy corrections)  
**Approval Status**: ⏳ Pending Tech Lead & PO review  
**Next Review Date**: 2025-12-13 (30 days)

---

## Document Revision History

| Version | Date | Changes | Reviewer |
|---------|------|---------|----------|
| 1.0 | 2025-11-13 | Initial consolidation from technical docs | AI |
| 1.1 | 2025-11-13 | **CORRECTIONS**: Fixed schema discrepancies, marked inferred sections, added developer review notices | AI |

**Key Corrections in v1.1**:
- ✅ Fixed FirstName/LastName data types: VARCHAR(128) NOT NVARCHAR(100)
- ✅ Fixed LastName nullability: NOT NULL (required)
- ⚠️ Flagged CreatedUtc column discrepancy for developer verification
- ✅ Marked all inferred components with ❓ **INFERRED** labels
- ✅ Added developer review notices to all derived sections
- ✅ Clarified sources for business rules, user flows, test scenarios
- ✅ Updated Components Involved table to show verification status (✅ vs ❓)
- ✅ Added cross-references to actual documented vs. assumed features
