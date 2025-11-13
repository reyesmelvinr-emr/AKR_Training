# Tag Taxonomy - Complete Reference

**Version**: 1.0  
**Date**: 2025-11-05  
**Purpose**: Define complete tag taxonomy for documentation system  
**Context**: Training Tracker POC (expandable for production)  
**Related**: [Tagging Strategy Overview](TAGGING_STRATEGY_OVERVIEW.md)

---

## Tag Categories

### 1. Feature Domain Tags

**Purpose**: Identify which business feature a component belongs to

**Format**: `#feature-name` (noun phrase, describes what the feature does)

**Usage**: 
- Technical docs: Link to feature docs
- Feature docs: Primary categorization
- Commit messages: Indicate which feature is affected

**Training Tracker Tags**:

#### User Management Domain
```
#user-profile          - User profile information and settings
#user-registration     - New user signup process
#user-authentication   - Login, logout, session management
#password-management   - Password reset, change password
#user-preferences      - User settings and customization
```

#### Course Management Domain
```
#course-catalog        - Browse and search courses
#course-management     - Admin CRUD operations on courses
#course-details        - Individual course information display
#course-prerequisites  - Course prerequisite system
#course-capacity       - Course enrollment capacity management
#country-based-access  - Country-specific course access rules
```

#### Enrollment Domain
```
#enrollment            - General course enrollment
#enrollment-validation - Enrollment business rule validation
#prerequisite-validation - Prerequisite checking logic
#enrollment-tracking   - Track enrollment status
#completion-tracking   - Course completion and progress
#unenrollment          - User withdrawal from courses
```

#### Admin Domain
```
#admin-panel           - Admin dashboard and navigation
#user-management       - Admin user CRUD operations
#course-management     - Admin course CRUD operations
#reporting             - Admin reports and analytics
#audit-logging         - System audit trail
```

#### Dashboard Domain
```
#user-dashboard        - User home/dashboard view
#admin-dashboard       - Admin home/dashboard view
#course-progress       - User course progress widgets
#recommendations       - Course recommendations
```

---

### 2. Cross-Cutting Concern Tags

**Purpose**: Identify components that implement system-wide concerns

**Format**: `#concern-name` (technical concern, not feature-specific)

**Usage**:
- Find all components using a specific concern (e.g., authentication)
- Audit cross-cutting implementations
- Impact analysis for infrastructure changes

**Tags**:

#### Security & Access Control
```
#authentication        - Login, session, token management
#authorization         - Role-based access control (RBAC)
#permissions           - Fine-grained permission checks
#oauth                 - OAuth integration
#jwt                   - JWT token generation/validation
#session-management    - User session handling
#password-security     - Password hashing, strength validation
```

#### Data & Compliance
```
#audit-logging         - System audit trail
#data-validation       - Input validation, sanitization
#data-privacy          - PII handling, GDPR compliance
#encryption            - Data encryption at rest/transit
#compliance            - Regulatory compliance requirements
```

#### Error Handling & Monitoring
```
#error-handling        - Exception handling, error responses
#logging               - Application logging
#monitoring            - Performance monitoring, metrics
#alerting              - System alerts and notifications
#health-checks         - Service health endpoints
```

#### Performance & Scalability
```
#caching               - Data caching strategies
#performance-optimization - Performance improvements
#indexing              - Database index optimization
#query-optimization    - SQL query tuning
#pagination            - Result pagination
#lazy-loading          - Deferred data loading
```

#### Integration & Communication
```
#email                 - Email sending functionality
#notifications         - System notifications
#api-integration       - External API integration
#webhooks              - Webhook handling
#messaging             - Message queue integration
```

---

### 3. Technical Component Tags

**Purpose**: Categorize by technical layer or component type

**Format**: `#component-type` (technical classification)

**Usage**:
- Filter documentation by layer (database, API, UI)
- Understand architecture at a glance
- Generate layer-specific reports

**Tags**:

#### Database Layer
```
#database              - General database-related
#table                 - Database table
#view                  - Database view
#stored-procedure      - Stored procedure
#function              - Database function
#trigger               - Database trigger
#index                 - Database index
#constraint            - Table constraints
#schema-change         - Schema modification
```

#### API Layer
```
#api                   - General API-related
#service               - Business logic service
#controller            - API controller
#endpoint              - REST endpoint
#middleware            - API middleware
#validation-logic      - Business rule validation
#repository            - Data access layer
#dto                   - Data transfer object
```

#### UI Layer
```
#ui                    - General UI-related
#ui-component          - Reusable UI component
#page                  - Full page component
#form                  - Form component
#button                - Button component
#modal                 - Modal/dialog component
#navigation            - Navigation component
#layout                - Layout/structure component
#styling               - CSS/styling-related
```

#### Shared/Infrastructure
```
#configuration         - App configuration
#dependency-injection  - DI container setup
#testing               - Test code/infrastructure
#build                 - Build configuration
#deployment            - Deployment scripts/config
```

---

### 4. Change Type Tags

**Purpose**: Categorize the type of change made to documentation

**Format**: `#change-type` (describes nature of change)

**Usage**:
- Filter consolidation by change type (e.g., only business rule changes)
- Prioritize reviews (business rule changes need PO approval)
- Generate release notes

**Tags**:

#### Feature Changes
```
#new-feature           - Brand new feature implementation
#enhancement           - Improvement to existing feature
#feature-deprecation   - Feature being phased out
#feature-removal       - Feature completely removed
```

#### Technical Changes
```
#bug-fix               - Bug fix documentation
#refactoring           - Code restructuring (no behavior change)
#performance-optimization - Performance improvement
#security-fix          - Security vulnerability fix
#technical-debt        - Technical debt reduction
```

#### Business Logic Changes
```
#business-rule-change  - Business rule added/modified
#validation-change     - Validation logic modified
#workflow-change       - User workflow modified
#calculation-change    - Calculation logic changed
```

#### Data & Schema Changes
```
#schema-change         - Database schema modified
#data-migration        - Data migration required
#breaking-change       - Breaking change (requires consumer updates)
#backwards-compatible  - Change is backwards compatible
```

#### Documentation Changes
```
#clarification         - Clarify existing documentation
#correction            - Fix documentation error
#expansion             - Add more detail to existing docs
#consolidation         - Merge/reorganize documentation
```

---

### 5. Priority Tags

**Purpose**: Indicate business priority or criticality

**Format**: `#priority-level` (business importance)

**Usage**:
- Prioritize documentation reviews
- Identify core vs. optional features
- Resource allocation decisions

**Tags**:

```
#core-feature          - P0: Core business function (must have)
#important             - P1: Important feature (should have)
#nice-to-have          - P2: Optional feature (could have)
#future                - P3: Future enhancement (won't have now)
#experimental          - Experimental/proof-of-concept feature
#deprecated            - Feature marked for removal
```

**Priority Matrix**:

| Tag | Description | Example | Doc Priority |
|-----|-------------|---------|--------------|
| `#core-feature` | Critical to business | Course Enrollment | Must document immediately |
| `#important` | Significant value | Course Recommendations | Document within sprint |
| `#nice-to-have` | Adds convenience | Dark mode theme | Document when time permits |
| `#future` | Planned enhancement | Mobile app | Reference only |
| `#experimental` | Testing/POC | AI-powered search | Optional documentation |

---

### 6. Status Tags

**Purpose**: Track feature/component status

**Format**: `#status-name` (current state)

**Usage**:
- Identify in-progress features (don't consolidate yet)
- Find deprecated components (mark for removal)
- Track POC features (different documentation standard)

**Tags**:

```
#in-development        - Currently being developed
#ready-for-testing     - Development complete, in QA
#deployed              - Deployed to production
#deprecated            - Marked for removal
#retired               - No longer in use
#poc                   - Proof of concept
#stable                - Production-ready, stable API
#beta                  - In beta/early access
```

---

## Tag Naming Conventions

### ✅ DO: Use Kebab-Case

```
✅ Good:
#country-based-access
#enrollment-validation
#user-profile
#business-rule-change
```

```
❌ Bad:
#CountryBasedAccess (PascalCase)
#enrollment_validation (snake_case)
#userProfile (camelCase)
#COUNTRY-ACCESS (all caps)
```

**Why**: Consistency aids automation (regex matching, parsing)

---

### ✅ DO: Be Specific But Not Too Granular

```
✅ Good (Goldilocks Zone):
#enrollment-validation
  - Covers prerequisite validation, country validation, capacity validation
  - Reusable across multiple features
  - Not so broad that everything matches

❌ Too Broad:
#validation
  - Too many features match
  - Not useful for filtering

❌ Too Granular:
#enrollment-country-prerequisite-validation
  - Only 1 feature matches
  - Not reusable
  - Creates tag explosion
```

**Rule of Thumb**: Tag should match 2-10 components/features

---

### ✅ DO: Use Nouns for Features, Verbs for Concerns

```
✅ Feature Tags (Nouns):
#enrollment
#user-profile
#course-catalog
#reporting

✅ Cross-Cutting Tags (Nouns or Gerunds):
#authentication
#logging
#caching
#monitoring
```

```
❌ Avoid Verbs for Features:
#enrolling (should be #enrollment)
#profiling (should be #user-profile)
```

---

### ✅ DO: Avoid Special Characters (Except Hyphen)

```
✅ Good:
#country-access
#user-profile
#enrollment-validation

❌ Bad:
#country_access (underscore)
#user.profile (period)
#enrollment/validation (slash)
#course*management (asterisk)
```

**Why**: Special characters break parsers and search

---

### ✅ DO: Keep Tags Concise (2-4 Words Max)

```
✅ Good:
#course-enrollment (2 words)
#prerequisite-validation (2 words)
#country-based-access (3 words)

❌ Too Long:
#course-enrollment-with-prerequisite-and-capacity-validation (8 words)
  → Split into: #enrollment, #prerequisite-validation, #capacity-management
```

---

## Tag Usage Guidelines

### How Many Tags Per Document?

**Technical Docs** (tables, services, components):
- **Minimum**: 3 tags (1 feature + 1 cross-cutting + 1 technical)
- **Recommended**: 5-8 tags
- **Maximum**: 12 tags (if more, component does too much - consider refactoring)

**Example** (`EnrollmentService_doc.md`):
```markdown
**Tags**: #enrollment #enrollment-validation #prerequisite-validation #country-access #authentication #audit-logging #service #business-logic
```
(8 tags: 4 feature, 2 cross-cutting, 2 technical)

**Feature Docs**:
- **Minimum**: 4 tags (1 domain + 1 priority + 2 related features)
- **Recommended**: 6-10 tags
- **Maximum**: 15 tags

**Example** (`course-enrollment.md`):
```markdown
**Tags**: #enrollment #prerequisites #validation #country-access #capacity #authentication #audit-logging #core-feature #stable
```
(9 tags: 5 feature, 2 cross-cutting, 1 priority, 1 status)

---

### Which Tags to Include?

**Required** (Every Doc Must Have):
1. **Primary feature tag** (e.g., `#enrollment`)
2. **At least one technical layer tag** (e.g., `#service`, `#table`, `#ui-component`)

**Recommended** (Should Include If Applicable):
3. **Cross-cutting concerns** (e.g., `#authentication`, `#audit-logging`)
4. **Related features** (e.g., `#prerequisite-validation` if enrollment checks prerequisites)
5. **Priority** (feature docs only: `#core-feature`, `#important`, etc.)

**Optional** (Include If Relevant):
6. **Status** (e.g., `#deprecated`, `#poc`)
7. **Change type** (commit messages: `#business-rule-change`, `#performance-optimization`)

---

### When to Add New Tags?

**Add New Tag If**:
- ✅ New feature/domain emerges (e.g., new `#mobile-app` domain)
- ✅ New cross-cutting concern added (e.g., `#rate-limiting`)
- ✅ Existing tags don't accurately describe component (gap in taxonomy)
- ✅ Tag would be used by 3+ components/features (reusable)

**Don't Add New Tag If**:
- ❌ Only 1-2 uses (too granular)
- ❌ Existing tag already covers it (duplicate)
- ❌ Too specific to one feature (use existing feature tag instead)

**Process for Adding New Tags**:
1. Check taxonomy (does tag already exist?)
2. Propose new tag in team chat/meeting
3. Tech Lead approves (ensures consistency)
4. Add to taxonomy document
5. Backfill existing docs if applicable
6. Announce to team

---

## Tag Combinations (Patterns)

### Pattern 1: Feature + Cross-Cutting + Technical

**Most Common Pattern**:
```markdown
**Tags**: #enrollment #authentication #audit-logging #service
```

**Breakdown**:
- `#enrollment` = Feature domain
- `#authentication` = Cross-cutting concern
- `#audit-logging` = Cross-cutting concern
- `#service` = Technical component type

**Enables**:
- Find all enrollment components (search `#enrollment`)
- Find all services (search `#service`)
- Find all components using auth (search `#authentication`)

---

### Pattern 2: Feature + Related Features

**Use Case**: Component touches multiple features
```markdown
**Tags**: #enrollment #course-catalog #user-profile #service
```

**Example**: `UserService` might handle enrollment, profile, and course browsing

**Enables**:
- Impact analysis: Change to UserService affects 3 features
- Feature docs for enrollment, catalog, and profile all reference UserService

---

### Pattern 3: Feature + Change Type (Commit Messages)

**Use Case**: Commit message indicates what changed
```bash
git commit -m "docs: add Country validation (FN12345_US123) #country-access #business-rule-change"
```

**Enables**:
- Filter consolidation: "Show only business rule changes" (needs PO review)
- Release notes: "What business rules changed this sprint?"

---

### Pattern 4: Feature + Priority (Feature Docs Only)

**Use Case**: Indicate business importance
```markdown
**Tags**: #enrollment #core-feature
```

**Enables**:
- Prioritize reviews: Core features reviewed first
- Documentation effort: Core features get 90%+ coverage, nice-to-have get 70%

---

## Tag Index (Alphabetical)

### A-E
```
#admin-dashboard
#admin-panel
#alerting
#api
#api-integration
#audit-logging
#authentication
#authorization
#backwards-compatible
#beta
#breaking-change
#bug-fix
#build
#business-rule-change
#button
#caching
#calculation-change
#capacity-management
#clarification
#compliance
#completion-tracking
#configuration
#constraint
#controller
#core-feature
#correction
#country-based-access
#course-capacity
#course-catalog
#course-details
#course-management
#course-prerequisites
#course-progress
#data-migration
#data-privacy
#data-validation
#database
#deprecated
#deployment
#dependency-injection
#dto
#email
#encryption
#endpoint
#enhancement
#enrollment
#enrollment-tracking
#enrollment-validation
#error-handling
#expansion
#experimental
```

### F-P
```
#feature-deprecation
#feature-removal
#form
#function
#future
#health-checks
#important
#in-development
#index
#indexing
#integration
#jwt
#lazy-loading
#layout
#logging
#messaging
#middleware
#modal
#monitoring
#navigation
#new-feature
#nice-to-have
#notifications
#oauth
#page
#pagination
#password-management
#password-security
#performance-optimization
#permissions
#poc
```

### Q-Z
```
#query-optimization
#ready-for-testing
#recommendations
#refactoring
#reporting
#repository
#retired
#schema-change
#security-fix
#service
#session-management
#stable
#stored-procedure
#styling
#table
#technical-debt
#testing
#trigger
#ui
#ui-component
#unenrollment
#user-authentication
#user-dashboard
#user-management
#user-preferences
#user-profile
#user-registration
#validation
#validation-change
#validation-logic
#view
#webhooks
#workflow-change
```

---

## Training Tracker Specific Tag Map

### Core Features → Tags

| Feature | Primary Tag | Related Tags |
|---------|-------------|--------------|
| Course Enrollment | `#enrollment` | `#validation`, `#prerequisites`, `#capacity` |
| Course Catalog | `#course-catalog` | `#filtering`, `#search`, `#country-access` |
| User Profile | `#user-profile` | `#authentication`, `#preferences` |
| Admin Panel | `#admin-panel` | `#user-management`, `#course-management` |
| Prerequisites | `#prerequisite-validation` | `#enrollment`, `#business-rules` |

### Cross-Cutting → Components

| Concern | Tag | Typical Components |
|---------|-----|-------------------|
| Authentication | `#authentication` | Users table, AuthService, LoginForm |
| Audit Logging | `#audit-logging` | AuditLog table, AuditService, Middleware |
| Validation | `#validation` | All services with business rules |
| Performance | `#performance-optimization` | Indexed tables, cached services |

---

## Tag Evolution History

### Version 1.0 (2025-11-05)

**Initial Tags** (Training Tracker POC):
- 15 Feature Domain tags
- 20 Cross-Cutting Concern tags
- 15 Technical Component tags
- 10 Change Type tags
- 6 Priority tags
- 8 Status tags

**Total**: ~74 tags

**Rationale**:
- Start lean (POC)
- Covers core Training Tracker features
- Expandable for production

---

### Version 2.0 (Planned: Q1 2026)

**Expected Additions** (Based on Feature Growth):
- `#mobile-support` (if mobile app developed)
- `#offline-mode` (if offline capability added)
- `#multi-language` (if i18n implemented)
- `#accessibility` (if WCAG compliance targeted)

**Expected Deprecations**:
- Remove unused POC-specific tags
- Merge duplicate tags discovered through usage

---

## Maintenance Schedule

### Weekly: Tag Usage Review (5 minutes)
- Review last week's commits
- Check if tags used consistently
- Identify missing tags (developer forgot to add)

### Monthly: Tag Analytics (15 minutes)
- Which tags used most? (popular features/concerns)
- Which tags never used? (candidates for removal)
- Any new patterns emerging? (need new tags?)

### Quarterly: Full Tag Audit (1-2 hours)
- Review entire taxonomy
- Merge duplicate tags
- Add new tags for emerging features
- Deprecate unused tags
- Update this document

---

## FAQ

### Q: How do I know which tags to use?

**A**: Start with the "Pattern 1" formula:
```
1 Feature Tag + 1-2 Cross-Cutting Tags + 1 Technical Tag = Baseline
```

**Example**:
```
EnrollmentService → #enrollment #authentication #service
Users table → #user-profile #authentication #table
CourseCard component → #course-catalog #ui-component
```

---

### Q: What if my component touches 10+ features?

**A**: This is a code smell - component might be doing too much.

**Options**:
1. **Refactor code** (split into smaller components)
2. **Use hierarchical tags** (e.g., `#enrollment` covers `#enrollment-validation`, `#enrollment-tracking`)
3. **Tag only primary features** (top 5 most related)

---

### Q: Should I tag every small utility function?

**A**: No. Tag threshold:

**DO Tag**:
- Business logic services
- Database tables/views
- UI components users interact with
- API endpoints
- Middleware/infrastructure components

**DON'T Tag** (or minimal tags):
- Utility functions (e.g., `FormatDate()`)
- Simple DTOs with no business logic
- Constants files
- Test helpers

---

### Q: Can I create project-specific tags outside this taxonomy?

**A**: Yes, but follow process:
1. Propose to Tech Lead (ensure not duplicate)
2. Add to taxonomy document
3. Use consistently

**Example**:
```
Project: SpecKit Integration
New Tag: #speckit-integration
Category: Feature Domain (integration-specific)
```

---

## Next Steps

1. **Read**: [Tagging Strategy Overview](TAGGING_STRATEGY_OVERVIEW.md) - Understand why tags matter
2. **Implement**: [Tag Implementation Guide](TAGGING_STRATEGY_IMPLEMENTATION.md) - How to add tags to docs
3. **Automate**: [Tag Automation Workflows](TAGGING_STRATEGY_AUTOMATION.md) - Scripts using tags
4. **Practice**: [Tag Examples](TAGGING_STRATEGY_EXAMPLE.md) - Real-world scenarios

---

**Document Version**: 1.0  
**Last Updated**: 2025-11-05  
**Next Review**: Monthly (December 5, 2025)  
**Owner**: Tech Lead
