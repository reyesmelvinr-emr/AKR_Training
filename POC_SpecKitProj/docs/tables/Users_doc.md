# Table: Users

## Metadata

**Component Type**: Table  
**Repository**: training-tracker-database  
**File Path**: `POC_SpecKitProj/training/Tables/Users.sql`  
**Last Updated**: 2025-11-12  
**Tags**: #user-profile #user-management #authentication #table #core-feature

---

**Schema/Namespace**: training  
**Object Type**: Table  
**Last Updated**: 2025-11-12

---

## Purpose

🤖 Stores user account information including email, names, and active status for the Training Tracker system.

❓ [HUMAN: Business context - why this table exists, what business need it addresses. For example: Central repository for all system users. Used for authentication, authorization, and personalization. Tracks employees who can enroll in training courses and manage their profiles.]

---

## Columns

🤖
- `Id` (GUID, Required, default: newsequentialid()) - **Primary Key** - Unique identifier for each user (native: UNIQUEIDENTIFIER)
- `Email` (String, max 256, Required) - User email address used for login and notifications (native: VARCHAR)
- `FirstName` (String, max 128, Required) - User's first name (native: VARCHAR)
- `LastName` (String, max 128, Required) - User's last name (native: VARCHAR)
- `IsActive` (Boolean, Required, default: true) - Indicates if the user account is active and can access the system (native: BIT)

---

## Constraints

🤖

**Primary Key:**
- `PK_Users` on (Id): Clustered index enforcing unique user identification

**Check Constraints:**
- `CK_Users_Email`: Email must be in a valid format containing '@' and at least one '.' after the '@'
  - Technical expression: `[Email] like '%@%.%'`
  - ❓ **Why**: Ensures only valid email addresses are stored for reliable authentication and communication. Basic format validation before application-level validation.

**Unique Constraints:**
- `UQ_Users_Email` on (Email): Email must be unique across all users
  - ❓ **Why**: Prevents duplicate user accounts and ensures reliable login. Each email can only be associated with one user account for authentication purposes.

**Foreign Keys:**
- 🤖 (None)

---

## Business Rules

🤖

| Rule ID         | Description                                              | Why It Exists                                           | Since When           |
|-----------------|----------------------------------------------------------|---------------------------------------------------------|----------------------|
| 🤖 BR-USERS-001 | Email must be unique                                     | ❓ Prevents duplicate accounts, ensures unique login ID | ❓                   |
| 🤖 BR-USERS-002 | Email must be valid format (contains @ and .)            | ❓ Ensures reliable communication and authentication    | ❓                   |
| 🤖 BR-USERS-003 | User account must be marked active or inactive           | ❓ Controls access to system features                   | ❓                   |
| 🤖 BR-USERS-004 | Sequential GUID used for primary key                     | ❓ Better performance than random GUID in clustered index | ❓                   |
| 🤖 BR-USERS-005 | New users are active by default                          | ❓ Immediate access upon account creation               | ❓                   |

❓ [HUMAN: Add context for non-obvious rules, historical reasons, or recent changes. For example: BR-USERS-003 added to support soft-delete pattern rather than hard deletes for compliance/audit requirements.]

---

## Related Objects

🤖

- **Views**: None known
- **Stored Procedures**: None - using ORM for CRUD operations
- **Triggers**: None
- **Referenced By**: 
  - 🤖 training.Enrollments (UserId) - Tracks user course enrollments
  - ❓ [HUMAN: Add other tables that reference Users, e.g., AuditLog, UserPreferences, UserRoles]

❓ [HUMAN: Add external system integrations if applicable. For example: LDAP/Active Directory sync, SSO provider integration, email notification service]

---

## Database-Specific Features

🤖
- **NEWSEQUENTIALID()** - SQL Server specific function for sequential GUID generation
  - Alternative in PostgreSQL: `UUID_GENERATE_V1()` or `GEN_RANDOM_UUID()`
  - Alternative in MySQL: Generate UUID in application layer or use `UUID_TO_BIN(UUID(), 1)`
  
- **UNIQUEIDENTIFIER** - SQL Server specific GUID data type
  - Alternative in PostgreSQL: `UUID`
  - Alternative in MySQL: `CHAR(36)` or `BINARY(16)`

- **BIT** - SQL Server specific boolean type
  - Alternative in PostgreSQL: `BOOLEAN`
  - Alternative in MySQL: `TINYINT(1)` or `BOOLEAN`

❓ [HUMAN: Document portability implications if migrating to different database. Examples:
- Migration to PostgreSQL: Table and column names would need to be lowercase per convention
- Migration to MySQL: VARCHAR max lengths may need adjustment based on charset (utf8mb4 uses 4 bytes per char)]

---

## Documentation Standards

### This template follows the Application Knowledge Repo (AKR) system

**For universal conventions, see**:
- [AKR_CHARTER.md](../../charters/AKR_CHARTER.md) - Core principles, generic data types, feature tags, Git format

**For database-specific conventions, see**:
- [AKR_CHARTER_DB.md](../../charters/AKR_CHARTER_DB.md) - Database object naming, constraints, patterns

**For step-by-step documentation process, see**:
- [Table_Documentation_Developer_Guide.md](../guides/Table_Documentation_Developer_Guide.md) - How to use this template with Copilot/AI

**For tagging strategy, see**:
- [TAGGING_STRATEGY_TAXONOMY.md](../../AKR_files/TAGGING_STRATEGY_TAXONOMY.md) - Complete tag reference
- [TAGGING_STRATEGY_OVERVIEW.md](../../AKR_files/TAGGING_STRATEGY_OVERVIEW.md) - Tagging system overview

---

## Change History

**Schema evolution is tracked in Git**, not in this document.

To see how this table evolved:
```bash
git log docs/tables/Users_doc.md
git log -p docs/tables/Users_doc.md
git log --grep="FN#####" docs/tables/Users_doc.md
```

**Include feature tags in commit messages**:
```bash
git commit -m "docs: update Users table - add Country column (FN#####_US#####) #user-profile #country-based-access"
```

---

## AI Generation Instructions

🤖
- All content above marked 🤖 is generated from schema and conventions.
- ❓ sections require human input for business context, rationale, and history.

**AI-generated tags rationale**:
- `#user-profile` - Table stores core user profile information (name, email)
- `#user-management` - Used for user account management operations
- `#authentication` - Email field used as login identifier
- `#table` - Component type classifier
- `#core-feature` - Essential table for system operation (all features depend on users)

---

## Template Metadata

**Template Version**: 3.0 (Separated from Developer Guide)  
**Last Updated**: 2025-11-12  
**Maintained By**: Architecture Team  
**Part of**: Application Knowledge Repo (AKR) system

**Related Files**:
- [Table_Documentation_Developer_Guide.md](../guides/Table_Documentation_Developer_Guide.md)
- [AKR_CHARTER.md](../../charters/AKR_CHARTER.md)
- [AKR_CHARTER_DB.md](../../charters/AKR_CHARTER_DB.md)
- [TAGGING_STRATEGY_TAXONOMY.md](../../AKR_files/TAGGING_STRATEGY_TAXONOMY.md)