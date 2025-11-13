# AKR System - Recommended Folder Structure

**Version**: 1.0  
**Date**: 2025-11-03  
**Purpose**: Define optimal folder structure for multi-repository AKR documentation system  
**Context**: Training Tracker POC with separate UI, API, and Database repositories

---

## Executive Summary

You now have a **complete AKR documentation system** with:
- ✅ **3 Charters**: Universal (AKR_CHARTER.md), Database (AKR_CHARTER_DB.md), UI (AKR_CHARTER_UI.md)
- ✅ **3 Template Families**: Database (1 template), Backend (4 templates), UI (1 template)
- ✅ **3 Developer Guides**: Database (in charter), Backend (35 KB), UI (41 KB)

**This document recommends**:
1. **Master repository structure** (AKR_Training - source of truth)
2. **Per-repository structure** (where documentation lives with code)
3. **Cross-repository linking strategy** (how repos reference each other)
4. **Migration path** (how to deploy the system)
5. **Feature documentation strategy** (business/functional documentation layer)

**Related Documents**:
- [Feature Documentation Strategy](FEATURE_DOCUMENTATION_STRATEGY.md) - Comprehensive guide for consolidating business/functional requirements

---

## Current State Analysis

### What You Have Now

**AKR_Training Repository** (Master Template Repository):
```
AKR_Training/
├── AKR files/                                    ← All charter/template files here
│   ├── AKR_CHARTER.md                           ← Universal charter
│   ├── AKR_CHARTER_DB.md                        ← Database charter
│   ├── AKR_CHARTER_UI.md                        ← UI charter
│   ├── AKR_CHARTER_BACKEND.md                   ← Backend charter
│   ├── AKR_CHARTER_BACKEND_ASSESSMENT.md        ← Backend charter assessment
│   ├── AKR_IMPLEMENTATION_ASSESSMENT.md         ← Implementation assessment
│   ├── AKR_FILES_SUMMARY.md                     ← Files summary
│   ├── table_doc_template.md                    ← Database template
│   ├── minimal_service_template.md              ← Backend template (minimal)
│   ├── lean_baseline_service_template.md        ← Backend template (recommended)
│   ├── standard_service_template.md             ← Backend template (standard)
│   ├── comprehensive_service_template.md        ← Backend template (comprehensive)
│   ├── backend_service_template_proposals.md    ← Backend template proposals
│   ├── ui_component_template.md                 ← UI template
│   ├── Backend_Service_Documentation_Developer_Guide.md  ← Backend developer guide
│   ├── Backend_Service_Documentation_Guide.md   ← Backend documentation guide
│   ├── UI_Component_Documentation_Developer_Guide.md     ← UI developer guide
│   ├── FEATURE_DOCUMENTATION_STRATEGY.md        ← Feature documentation strategy
│   ├── TAGGING_STRATEGY_OVERVIEW.md             ← Tagging strategy overview
│   ├── TAGGING_STRATEGY_TAXONOMY.md             ← Tagging taxonomy
│   ├── TAGGING_STRATEGY_IMPLEMENTATION.md       ← Tagging implementation
│   ├── GITHUB_COPILOT_SPACES_REFERENCE.md       ← Copilot Spaces reference
│   ├── PRESENTATION_AKR_SYSTEM_AND_COPILOT_SPACES.md  ← System presentation
│   ├── PRESENTATION_AKR_MONOREPO_ANALYSIS.md    ← Monorepo analysis presentation
│   ├── PRESENTATION_SPEAKER_NOTES.md            ← Speaker notes (system)
│   └── PRESENTATION_MONOREPO_SPEAKER_NOTES.md   ← Speaker notes (monorepo)
├── backend/                                      ← POC backend code
├── training-tracker-ui/                          ← POC UI code
├── POC_SpecKitProj/                              ← POC database project (SSDT)
├── scripts/                                      ← Database scripts
└── [other POC files]
```

### Current POC Repositories Within AKR_Training

**Current structure**:
- **POC_SpecKitProj** - SSDT Database Project (SQL Server) - Currently in AKR_Training folder
- **backend** - Backend API (ASP.NET Core) - Currently in AKR_Training folder
- **training-tracker-ui** - React Frontend (TypeScript + Vite) - Currently in AKR_Training folder

**Future consideration**: These may be split into separate repositories later.

**Question**: Where should documentation live?

---

## Recommended Structure

### Option A: Distributed Documentation (RECOMMENDED)

**Philosophy**: Documentation lives with code, charters copied to each repo.

#### Structure Overview

```
┌─────────────────────────────────────────────────────────────┐
│ AKR_Training (Master Template Repo)                          │
│ - Source of truth for charters and templates                 │
│ - Updates pushed to production repos as needed               │
└─────────────────────────────────────────────────────────────┘
                          ↓ Syncs to ↓
    ┌───────────────────────┬─────────────────────┬────────────────────┐
    ↓                       ↓                     ↓                    ↓
┌─────────────────┐  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐
│ training-tracker│  │ training-tracker │  │ training-tracker │  │ Knowledge    │
│ -database       │  │ -api             │  │ -ui              │  │ Domain Repo  │
│                 │  │                  │  │                  │  │ (Optional)   │
│ Has: Database   │  │ Has: Backend     │  │ Has: UI          │  │              │
│ docs only       │  │ docs only        │  │ docs only        │  │ Has: Cross-  │
│                 │  │                  │  │                  │  │ repo docs    │
└─────────────────┘  └──────────────────┘  └──────────────────┘  └──────────────┘
```

---

### 1. Master Repository: AKR_Training

**Purpose**: Source of truth for all charters, templates, and guides

**Recommended Structure**:

```
AKR_Training/
├── README.md                                    ← Overview of AKR system
├── .gitignore
│
├── charters/                                    ← NEW: Consolidated charter location
│   ├── AKR_CHARTER.md                          ← Universal charter
│   ├── AKR_CHARTER_DB.md                       ← Database charter
│   ├── AKR_CHARTER_BACKEND.md                  ← Backend/API charter
│   └── AKR_CHARTER_UI.md                       ← UI/Frontend charter
│
├── templates/                                   ← NEW: All templates here
│   ├── database/
│   │   ├── table_doc_template.md
│   │   ├── view_doc_template.md               ← Future
│   │   └── stored_procedure_doc_template.md   ← Future
│   │
│   ├── backend/
│   │   ├── minimal_service_template.md
│   │   ├── lean_baseline_service_template.md  ← Recommended default
│   │   ├── standard_service_template.md
│   │   └── comprehensive_service_template.md
│   │
│   └── ui/
│       ├── ui_component_template.md
│       ├── minimal_ui_component_template.md   ← Future
│       └── comprehensive_ui_component_template.md  ← Future
│
├── guides/                                      ← NEW: Developer how-to guides
│   ├── Backend_Service_Documentation_Developer_Guide.md
│   ├── Backend_Service_Documentation_Guide.md
│   ├── UI_Component_Documentation_Developer_Guide.md
│   └── Database_Documentation_Developer_Guide.md  ← Future (extract from DB charter)
│
├── features/                                    ← NEW: Business/functional documentation
│   ├── README.md                               ← Feature index (by domain, user story, component)
│   ├── courses/                                ← Course-related features
│   │   ├── README.md
│   │   ├── course-catalog.md
│   │   ├── course-management.md
│   │   └── course-prerequisites.md
│   │
│   ├── users/                                  ← User-related features
│   │   ├── README.md
│   │   ├── user-registration.md
│   │   └── user-authentication.md
│   │
│   ├── enrollments/                            ← Enrollment-related features
│   │   ├── README.md
│   │   ├── course-enrollment.md
│   │   └── enrollment-tracking.md
│   │
│   ├── admin/                                  ← Admin features
│   │   ├── README.md
│   │   └── user-management.md
│   │
│   ├── dashboard/                              ← Dashboard features
│   │   ├── README.md
│   │   └── user-dashboard.md
│   │
│   └── cross-cutting/                          ← Cross-domain features
│       ├── README.md
│       ├── authentication/
│       ├── authorization/
│       ├── audit-logging/
│       └── error-handling/
│
├── assessments/                                 ← NEW: Assessment documents
│   ├── AKR_IMPLEMENTATION_ASSESSMENT.md
│   ├── AKR_CHARTER_BACKEND_ASSESSMENT.md
│   └── backend_service_template_proposals.md
│
├── presentations/                               ← NEW: Presentation documents
│   ├── PRESENTATION_AKR_SYSTEM_AND_COPILOT_SPACES.md
│   ├── PRESENTATION_SPEAKER_NOTES.md
│   ├── PRESENTATION_AKR_MONOREPO_ANALYSIS.md
│   └── PRESENTATION_MONOREPO_SPEAKER_NOTES.md
│
├── strategies/                                  ← NEW: Strategy documents
│   ├── FEATURE_DOCUMENTATION_STRATEGY.md
│   ├── TAGGING_STRATEGY_OVERVIEW.md
│   ├── TAGGING_STRATEGY_TAXONOMY.md
│   ├── TAGGING_STRATEGY_IMPLEMENTATION.md
│   └── AKR_FOLDER_STRUCTURE_RECOMMENDATION.md
│
├── references/                                  ← NEW: Reference documents
│   ├── GITHUB_COPILOT_SPACES_REFERENCE.md
│   └── AKR_FILES_SUMMARY.md
│
├── examples/                                    ← NEW: Example documentation
│   ├── database/
│   │   ├── Courses_doc_example.md             ← Future: Fully documented table
│   │   └── Users_doc_example.md               ← Future
│   │
│   ├── backend/
│   │   ├── CourseService_doc_example.md       ← Future: Fully documented service
│   │   └── EnrollmentService_doc_example.md   ← Future
│   │
│   └── ui/
│       ├── Button_doc_example.md              ← Future: Fully documented component
│       └── CourseCard_doc_example.md          ← Future
│
├── scripts/                                     ← Database scripts (keep existing)
│   ├── LocalDbTools.ps1
│   ├── Seed_Training_Data.sql
│   └── Test-AllEndpoints.ps1
│
├── poc/                                         ← NEW: Rename/reorganize POC code
│   ├── backend/                                ← Existing backend POC
│   ├── ui/                                     ← Existing UI POC (rename from training-tracker-ui)
│   └── database/                               ← Existing database scripts
│
├── archive/                                     ← Keep existing archive
│   └── [old implementation docs]
│
└── docs/                                        ← NEW: AKR system documentation
    ├── GETTING_STARTED.md                      ← Quick start guide
    ├── FOLDER_STRUCTURE.md                     ← This document
    ├── DEPLOYMENT_GUIDE.md                     ← How to deploy to production repos
    └── FAQ.md                                   ← Common questions
```

**Key Changes**:
1. ✅ **Consolidated structure** - Charters, templates, guides in clear folders
2. ✅ **Features folder** - Business/functional documentation (NEW - see [Feature Documentation Strategy](FEATURE_DOCUMENTATION_STRATEGY.md))
3. ✅ **Presentations folder** - All presentation materials organized
4. ✅ **Strategies folder** - Documentation and tagging strategies
5. ✅ **References folder** - Quick reference materials
6. ✅ **Examples folder** - Show complete documentation examples
7. ✅ **Clear separation** - POC code vs AKR system files
8. ✅ **Future-ready** - Space for additional templates and guides

---

### 2. Database Repository: POC_SpecKitProj (Current Location)

**Purpose**: SSDT Database Project + database documentation

**Current Structure**:

```
POC_SpecKitProj/
├── POC_SpecKitProj.sln                          ← Solution file
├── .vs/                                         ← Visual Studio cache
│
└── POC_SpecKitProj/                             ← SSDT project
    ├── POC_SpecKitProj.sqlproj                  ← SQL Server Database Project
    ├── POC_SpecKitProj.dbmdl
    ├── POC_SpecKitProj.jfm
    ├── POC_SpecKitProj.sqlproj.user
    │
    ├── Security/                                ← Security objects
    │
    ├── training/                                ← Training schema
    │   ├── Tables/
    │   │   ├── Courses.sql
    │   │   ├── Users.sql
    │   │   ├── Enrollments.sql
    │   │   ├── EnrollmentStatus.sql
    │   │   └── CoursePrerequisites.sql
    │   │
    │   └── Views/
    │       └── vw_CourseEnrollmentSummary.sql
    │
    ├── bin/                                     ← Build output
    ├── obj/                                     ← Build intermediate
    └── Import Schema Logs/                      ← Schema import logs
```

**Recommended Structure** (with documentation):

```
POC_SpecKitProj/
├── README.md                                    ← Repo overview
├── .gitignore
├── POC_SpecKitProj.sln
│
├── POC_SpecKitProj/                             ← SSDT project (existing)
│   ├── POC_SpecKitProj.sqlproj
│   ├── Security/
│   ├── training/
│   │   ├── Tables/
│   │   │   ├── Courses.sql
│   │   │   ├── Users.sql
│   │   │   ├── Enrollments.sql
│   │   │   ├── EnrollmentStatus.sql
│   │   │   └── CoursePrerequisites.sql
│   │   │
│   │   └── Views/
│   │       └── vw_CourseEnrollmentSummary.sql
│   │
│   ├── bin/
│   ├── obj/
│   └── Import Schema Logs/
│
├── docs/                                        ← NEW: Documentation folder
│   ├── charters/                               ← DATABASE-SPECIFIC charters only
│   │   ├── AKR_CHARTER.md                     ← Universal charter (copy)
│   │   └── AKR_CHARTER_DB.md                  ← Database charter (copy)
│   │
│   ├── templates/                              ← DATABASE-SPECIFIC templates only
│   │   ├── table_doc_template.md
│   │   ├── view_doc_template.md               ← Future
│   │   └── stored_procedure_doc_template.md   ← Future
│   │
│   ├── tables/                                 ← Table documentation
│   │   ├── Courses_doc.md
│   │   ├── Users_doc.md
│   │   ├── Enrollments_doc.md
│   │   ├── EnrollmentStatus_doc.md
│   │   └── CoursePrerequisites_doc.md
│   │
│   ├── views/                                  ← View documentation
│   │   └── vw_CourseEnrollmentSummary_doc.md
│   │
│   ├── stored-procedures/                      ← SP documentation (future)
│   │   └── [future stored procedure docs]
│   │
│   └── README.md                               ← Documentation index
│
├── scripts/                                     ← Database scripts (future)
│   ├── migrations/
│   ├── seed-data/
│   └── maintenance/
│
└── tests/                                       ← Database tests (future)
    └── [test files]
```

**Note**: Only database-specific charters and templates. NO backend or UI files here.

**Documentation Index Example** (`docs/README.md`):

```markdown
# Training Tracker Database Documentation

## Schema: training

### Tables

### Tables

| Table | Status | Last Updated | Description |
|-------|--------|--------------|-------------|
| [Courses](tables/Courses_doc.md) | ❌ Not Started | - | Course catalog |
| [Users](tables/Users_doc.md) | ❌ Not Started | - | System users |
| [Enrollments](tables/Enrollments_doc.md) | ❌ Not Started | - | Course enrollments |
| [EnrollmentStatus](tables/EnrollmentStatus_doc.md) | ❌ Not Started | - | Enrollment status lookup |
| [CoursePrerequisites](tables/CoursePrerequisites_doc.md) | ❌ Not Started | - | Course prerequisites |

### Views

| View | Status | Description |
|------|--------|-------------|
| [vw_CourseEnrollmentSummary](views/vw_CourseEnrollmentSummary_doc.md) | ❌ Not Started | Course enrollment summary |

## Documentation Standards

All documentation follows:
- [AKR Charter](charters/AKR_CHARTER.md) - Universal principles
- [Database Charter](charters/AKR_CHARTER_DB.md) - Database conventions
```

---

### 3. Backend API Repository: training-tracker-api

**Purpose**: ASP.NET Core API + backend service documentation

**Recommended Structure**:

```
training-tracker-api/
├── README.md
├── .gitignore
│
├── TrainingTracker.Api/                         ← API project (existing)
│   ├── Controllers/
│   ├── Services/
│   ├── Domain/
│   ├── Infrastructure/
│   ├── Contracts/
│   └── [other API folders]
│
├── TrainingTracker.Tests/                       ← Tests (existing)
│
├── docs/                                        ← NEW: Documentation folder
│   ├── charters/                               ← BACKEND-SPECIFIC charters only
│   │   ├── AKR_CHARTER.md                     ← Universal charter (copy)
│   │   └── AKR_CHARTER_BACKEND.md             ← Backend charter (copy)
│   │
│   ├── templates/                              ← BACKEND-SPECIFIC templates only
│   │   ├── minimal_service_template.md
│   │   ├── lean_baseline_service_template.md  ← Recommended default
│   │   ├── standard_service_template.md
│   │   └── comprehensive_service_template.md
│   │
│   ├── guides/                                 ← BACKEND-SPECIFIC guide only
│   │   └── Backend_Service_Documentation_Developer_Guide.md
│   │
│   ├── services/                               ← Service documentation
│   │   ├── CourseService_doc.md
│   │   ├── EnrollmentService_doc.md
│   │   ├── UserService_doc.md
│   │   └── AdminService_doc.md
│   │
│   ├── api/                                    ← API endpoint documentation (future)
│   │   ├── courses_api_doc.md
│   │   ├── enrollments_api_doc.md
│   │   └── users_api_doc.md
│   │
│   ├── architecture/                           ← Architecture docs (existing - move here)
│   │   ├── system-overview.md
│   │   ├── backend-architecture.md
│   │   └── deployment.md
│   │
│   └── README.md                               ← Documentation index
│
└── scripts/                                     ← Utility scripts
    └── [build, test, deploy scripts]
```

**Note**: Only backend-specific charters, templates, and guides. NO database or UI files here.

**Documentation Index Example** (`docs/README.md`):

```markdown
# Training Tracker API Documentation

## Services

| Service | Complexity | Status | Last Updated | Description |
|---------|-----------|--------|--------------|-------------|
| [CourseService](services/CourseService_doc.md) | Medium | ✅ Documented | 2025-11-03 | Course management |
| [EnrollmentService](services/EnrollmentService_doc.md) | Complex | ✅ Documented | 2025-11-03 | Enrollment operations |
| [UserService](services/UserService_doc.md) | Simple | ✅ Documented | 2025-11-03 | User management |
| [AdminService](services/AdminService_doc.md) | Complex | 📝 In Progress | - | Admin operations |

## API Endpoints

| Endpoint | HTTP Method | Service | Status |
|----------|-------------|---------|--------|
| `/api/courses` | GET | CourseService | ✅ Documented |
| `/api/courses/{id}` | GET | CourseService | ✅ Documented |
| `/api/enrollments` | POST | EnrollmentService | ❌ Not Started |

## Architecture

- [System Overview](architecture/system-overview.md)
- [Backend Architecture](architecture/backend-architecture.md)
- [Deployment Guide](architecture/deployment.md)

## Documentation Standards

All documentation follows:
- [AKR Charter](charters/AKR_CHARTER.md) - Universal principles
- [Backend Charter](charters/AKR_CHARTER_BACKEND.md) - Backend conventions
- [Developer Guide](guides/Backend_Service_Documentation_Developer_Guide.md) - How-to guide
```

---

### 4. UI Repository: training-tracker-ui

**Purpose**: React/TypeScript UI + component documentation

**Recommended Structure**:

```
training-tracker-ui/
├── README.md
├── .gitignore
├── package.json
├── vite.config.ts
├── tsconfig.json
│
├── src/                                         ← UI source code (existing)
│   ├── components/
│   │   ├── common/
│   │   ├── admin/
│   │   ├── courses/
│   │   └── dashboard/
│   ├── pages/
│   ├── services/
│   ├── hooks/
│   └── utils/
│
├── docs/                                        ← NEW: Documentation folder
│   ├── charters/                               ← UI-SPECIFIC charters only
│   │   ├── AKR_CHARTER.md                     ← Universal charter (copy)
│   │   └── AKR_CHARTER_UI.md                  ← UI charter (copy)
│   │
│   ├── templates/                              ← UI-SPECIFIC templates only
│   │   ├── ui_component_template.md
│   │   ├── minimal_ui_component_template.md   ← Future
│   │   └── comprehensive_ui_component_template.md  ← Future
│   │
│   ├── guides/                                 ← UI-SPECIFIC guide only
│   │   └── UI_Component_Documentation_Developer_Guide.md
│   │
│   ├── components/                             ← Component documentation
│   │   ├── common/
│   │   │   ├── Button_doc.md
│   │   │   ├── Card_doc.md
│   │   │   ├── Table_doc.md
│   │   │   ├── Modal_doc.md
│   │   │   └── Layout_doc.md
│   │   │
│   │   ├── courses/
│   │   │   ├── CourseCard_doc.md
│   │   │   └── CourseList_doc.md
│   │   │
│   │   └── admin/
│   │       ├── AdminPanel_doc.md
│   │       └── UserTable_doc.md
│   │
│   ├── pages/                                  ← Page documentation (future)
│   │   ├── Dashboard_doc.md
│   │   └── CourseCatalog_doc.md
│   │
│   ├── hooks/                                  ← Custom hooks documentation (future)
│   │   ├── useAuth_doc.md
│   │   └── useCourses_doc.md
│   │
│   ├── architecture/                           ← Architecture docs (existing - move here)
│   │   ├── frontend-architecture.md
│   │   └── component-patterns.md
│   │
│   └── README.md                               ← Documentation index
│
├── public/                                      ← Static assets
└── tests/                                       ← Tests
```

**Note**: Only UI-specific charters, templates, and guides. NO database or backend files here.

**Documentation Index Example** (`docs/README.md`):

```markdown
# Training Tracker UI Documentation

## Components

### Common Components (Reusable)

| Component | Type | Status | Last Updated | Description |
|-----------|------|--------|--------------|-------------|
| [Button](components/common/Button_doc.md) | Presentational | ✅ Documented | 2025-11-03 | Reusable button |
| [Card](components/common/Card_doc.md) | Container | ✅ Documented | 2025-11-03 | Card container |
| [Table](components/common/Table_doc.md) | Complex | 📝 In Progress | - | Data table |
| [Modal](components/common/Modal_doc.md) | Container | ❌ Not Started | - | Modal dialog |
| [Layout](components/common/Layout_doc.md) | Container | ❌ Not Started | - | Page layout |

### Domain Components (Feature-Specific)

| Component | Type | Status | Description |
|-----------|------|--------|-------------|
| [CourseCard](components/courses/CourseCard_doc.md) | Composite | ❌ Not Started | Course display card |
| [CourseList](components/courses/CourseList_doc.md) | Container | ❌ Not Started | Course list view |
| [AdminPanel](components/admin/AdminPanel_doc.md) | Page | ❌ Not Started | Admin interface |

## Pages

| Page | Status | Description |
|------|--------|-------------|
| [Dashboard](pages/Dashboard_doc.md) | ❌ Not Started | Main dashboard |
| [CourseCatalog](pages/CourseCatalog_doc.md) | ❌ Not Started | Course catalog |

## Custom Hooks

| Hook | Status | Description |
|------|--------|-------------|
| [useAuth](hooks/useAuth_doc.md) | ❌ Not Started | Authentication hook |
| [useCourses](hooks/useCourses_doc.md) | ❌ Not Started | Course data hook |

## Architecture

- [Frontend Architecture](architecture/frontend-architecture.md)
- [Component Patterns](architecture/component-patterns.md)

## Documentation Standards

All documentation follows:
- [AKR Charter](charters/AKR_CHARTER.md) - Universal principles
- [UI Charter](charters/AKR_CHARTER_UI.md) - UI conventions
- [Developer Guide](guides/UI_Component_Documentation_Developer_Guide.md) - How-to guide
```

---

## Cross-Repository Linking Strategy

### Problem: Documentation References Across Repos

**Example**: UI component calls backend API which queries database table.

```
Button component (UI repo)
    ↓ calls
EnrollmentService (API repo)
    ↓ queries
Enrollments table (Database repo)
```

**How to link documentation across repos?**

---

### Solution 1: Relative Paths (Git Submodules or Monorepo)

**If using Git submodules** or **monorepo structure**:

```markdown
## Related Documentation

**Backend API**:
- [EnrollmentService](../../training-tracker-api/docs/services/EnrollmentService_doc.md)
- [POST /api/enrollments](../../training-tracker-api/docs/api/enrollments_api_doc.md)

**Database**:
- [Enrollments table](../../training-tracker-database/docs/tables/Enrollments_doc.md)
```

**Pros**: Links work locally in IDE  
**Cons**: Only works if repos are co-located

---

### Solution 2: Repository URLs (Separate Repos)

**If using separate repositories** (most common):

```markdown
## Related Documentation

**Backend API**:
- [EnrollmentService](https://github.com/your-org/training-tracker-api/blob/main/docs/services/EnrollmentService_doc.md)
- [POST /api/enrollments](https://github.com/your-org/training-tracker-api/blob/main/docs/api/enrollments_api_doc.md)

**Database**:
- [Enrollments table](https://github.com/your-org/training-tracker-database/blob/main/docs/tables/Enrollments_doc.md)
```

**Pros**: Works from anywhere (browser, CI/CD)  
**Cons**: Links don't work locally in IDE

---

### Solution 3: Documentation Portal (Long-Term)

**If using documentation portal** (Confluence, Azure DevOps Wiki, GitHub Pages):

```markdown
## Related Documentation

**Backend API**:
- [EnrollmentService](https://docs.company.com/training-tracker/api/enrollment-service)
- [POST /api/enrollments](https://docs.company.com/training-tracker/api/enrollments-endpoint)

**Database**:
- [Enrollments table](https://docs.company.com/training-tracker/database/enrollments-table)
```

**Pros**: Single URL namespace, works everywhere  
**Cons**: Requires documentation portal infrastructure

---

### Recommended Approach

**Start simple** (Solution 2 - Repository URLs):

1. Use GitHub/Azure DevOps URLs for cross-repo references
2. Create README.md index files in each repo with links to other repos
3. Consider monorepo or documentation portal later if needed

**Example cross-repo reference template**:

```markdown
## Related Documentation

### Backend API
- Service: [EnrollmentService](https://github.com/your-org/training-tracker-api/blob/main/docs/services/EnrollmentService_doc.md)
- Endpoint: [POST /api/enrollments](https://github.com/your-org/training-tracker-api/blob/main/docs/api/enrollments_api_doc.md)

### Database
- Table: [Enrollments](https://github.com/your-org/training-tracker-database/blob/main/docs/tables/Enrollments_doc.md)
- Business Rules: See Enrollments table documentation

### UI Components (Consumers)
- [EnrollmentForm](https://github.com/your-org/training-tracker-ui/blob/main/docs/components/courses/EnrollmentForm_doc.md)
- [EnrollmentList](https://github.com/your-org/training-tracker-ui/blob/main/docs/components/admin/EnrollmentList_doc.md)
```

---

## Migration Path (Step-by-Step)

### Phase 1: Reorganize AKR_Training (This Week)

**Goal**: Clean up master repository structure

**Steps**:

1. **Create new folder structure** in AKR_Training:
   ```powershell
   cd "C:\Users\E1481541\OneDrive - Emerson\Documents\CDS - Team Hawkeye\AKR_Training"
   
   # Create new folders
   New-Item -ItemType Directory -Path "charters" -Force
   New-Item -ItemType Directory -Path "templates\database" -Force
   New-Item -ItemType Directory -Path "templates\backend" -Force
   New-Item -ItemType Directory -Path "templates\ui" -Force
   New-Item -ItemType Directory -Path "guides" -Force
   New-Item -ItemType Directory -Path "features\courses" -Force
   New-Item -ItemType Directory -Path "features\users" -Force
   New-Item -ItemType Directory -Path "features\enrollments" -Force
   New-Item -ItemType Directory -Path "features\admin" -Force
   New-Item -ItemType Directory -Path "features\dashboard" -Force
   New-Item -ItemType Directory -Path "features\cross-cutting\authentication" -Force
   New-Item -ItemType Directory -Path "features\cross-cutting\authorization" -Force
   New-Item -ItemType Directory -Path "features\cross-cutting\audit-logging" -Force
   New-Item -ItemType Directory -Path "features\cross-cutting\error-handling" -Force
   New-Item -ItemType Directory -Path "assessments" -Force
   New-Item -ItemType Directory -Path "presentations" -Force
   New-Item -ItemType Directory -Path "strategies" -Force
   New-Item -ItemType Directory -Path "references" -Force
   New-Item -ItemType Directory -Path "examples\database" -Force
   New-Item -ItemType Directory -Path "examples\backend" -Force
   New-Item -ItemType Directory -Path "examples\ui" -Force
   New-Item -ItemType Directory -Path "docs" -Force
   ```

2. **Move files to new structure**:
   ```powershell
   # Move charters
   Copy-Item "AKR files\AKR_CHARTER.md" "charters\" -Force
   Copy-Item "AKR files\AKR_CHARTER_DB.md" "charters\" -Force
   Copy-Item "AKR files\AKR_CHARTER_BACKEND.md" "charters\" -Force
   Copy-Item "AKR files\AKR_CHARTER_UI.md" "charters\" -Force
   
   # Move database templates
   Copy-Item "AKR files\table_doc_template.md" "templates\database\" -Force
   
   # Move backend templates
   Copy-Item "AKR files\minimal_service_template.md" "templates\backend\" -Force
   Copy-Item "AKR files\lean_baseline_service_template.md" "templates\backend\" -Force
   Copy-Item "AKR files\standard_service_template.md" "templates\backend\" -Force
   Copy-Item "AKR files\comprehensive_service_template.md" "templates\backend\" -Force
   
   # Move UI templates
   Copy-Item "AKR files\ui_component_template.md" "templates\ui\" -Force
   
   # Move guides
   Copy-Item "AKR files\Backend_Service_Documentation_Developer_Guide.md" "guides\" -Force
   Copy-Item "AKR files\Backend_Service_Documentation_Guide.md" "guides\" -Force
   Copy-Item "AKR files\UI_Component_Documentation_Developer_Guide.md" "guides\" -Force
   
   # Move assessments
   Copy-Item "AKR files\AKR_IMPLEMENTATION_ASSESSMENT.md" "assessments\" -Force
   Copy-Item "AKR files\AKR_CHARTER_BACKEND_ASSESSMENT.md" "assessments\" -Force
   Copy-Item "AKR files\backend_service_template_proposals.md" "assessments\" -Force
   
   # Move presentations
   Copy-Item "AKR files\PRESENTATION_AKR_SYSTEM_AND_COPILOT_SPACES.md" "presentations\" -Force
   Copy-Item "AKR files\PRESENTATION_SPEAKER_NOTES.md" "presentations\" -Force
   Copy-Item "AKR files\PRESENTATION_AKR_MONOREPO_ANALYSIS.md" "presentations\" -Force
   Copy-Item "AKR files\PRESENTATION_MONOREPO_SPEAKER_NOTES.md" "presentations\" -Force
   
   # Move strategies
   Copy-Item "AKR files\FEATURE_DOCUMENTATION_STRATEGY.md" "strategies\" -Force
   Copy-Item "AKR files\TAGGING_STRATEGY_OVERVIEW.md" "strategies\" -Force
   Copy-Item "AKR files\TAGGING_STRATEGY_TAXONOMY.md" "strategies\" -Force
   Copy-Item "AKR files\TAGGING_STRATEGY_IMPLEMENTATION.md" "strategies\" -Force
   Copy-Item "AKR files\AKR_FOLDER_STRUCTURE_RECOMMENDATION.md" "strategies\" -Force
   
   # Move references
   Copy-Item "AKR files\GITHUB_COPILOT_SPACES_REFERENCE.md" "references\" -Force
   Copy-Item "AKR files\AKR_FILES_SUMMARY.md" "references\" -Force
   ```

3. **Create documentation index files**:
   - `README.md` (root) - Overview of AKR system
   - `features/README.md` - Feature index (by domain, user story, component)
   - `docs/GETTING_STARTED.md` - Quick start guide
   - `docs/FOLDER_STRUCTURE.md` - Copy of this document
   - `docs/DEPLOYMENT_GUIDE.md` - How to deploy to production repos

4. **Commit changes**:
   ```bash
   git add .
   git commit -m "docs: reorganize AKR system folder structure (FN99999_US###)"
   git push
   ```

---

### Phase 2: Deploy to Database Repository (Next Week)

**Goal**: Set up documentation in POC_SpecKitProj repo

**Steps**:

1. **Create folder structure** in POC_SpecKitProj:
   ```powershell
   cd "C:\Users\E1481541\OneDrive - Emerson\Documents\CDS - Team Hawkeye\AKR_Training\POC_SpecKitProj"
   
   New-Item -ItemType Directory -Path "docs\charters" -Force
   New-Item -ItemType Directory -Path "docs\templates" -Force
   New-Item -ItemType Directory -Path "docs\tables" -Force
   New-Item -ItemType Directory -Path "docs\views" -Force
   New-Item -ItemType Directory -Path "docs\stored-procedures" -Force
   ```

2. **Copy DATABASE-SPECIFIC charters and templates** from AKR_Training:
   ```powershell
   # Copy charters (Universal + Database only)
   Copy-Item "..\charters\AKR_CHARTER.md" "docs\charters\" -Force
   Copy-Item "..\charters\AKR_CHARTER_DB.md" "docs\charters\" -Force
   
   # Copy database templates only (NO backend or UI templates)
   Copy-Item "..\templates\database\*" "docs\templates\" -Force
   ```

3. **Create documentation index**:
   - Create `docs/README.md` with table of contents
   - List all tables (Courses, Users, Enrollments, EnrollmentStatus, CoursePrerequisites)
   - List all views (vw_CourseEnrollmentSummary)
   - Mark documentation status

4. **Document first table** (test the system):
   - Use Copilot + table_doc_template.md
   - Document Courses table (training.Tables.Courses.sql)
   - Create `docs/tables/Courses_doc.md`
   - Time the process (target: 15-30 minutes)

5. **Commit**:
   ```bash
   cd POC_SpecKitProj
   git add docs/
   git commit -m "docs: add AKR documentation system (FN99999_US###)"
   git push
   ```

---

### Phase 3: Deploy to Backend API Repository (Week 3)

**Goal**: Set up documentation in training-tracker-api repo

**Steps**:

1. **Create folder structure** in training-tracker-api:
   ```powershell
   cd "path\to\training-tracker-api"
   
   New-Item -ItemType Directory -Path "docs\charters" -Force
   New-Item -ItemType Directory -Path "docs\templates" -Force
   New-Item -ItemType Directory -Path "docs\guides" -Force
   New-Item -ItemType Directory -Path "docs\services" -Force
   New-Item -ItemType Directory -Path "docs\api" -Force
   New-Item -ItemType Directory -Path "docs\architecture" -Force
   ```

2. **Copy BACKEND-SPECIFIC charters, templates, and guides** from AKR_Training:
   ```powershell
   # Copy charters (Universal + Backend only)
   Copy-Item "..\..\AKR_Training\charters\AKR_CHARTER.md" "docs\charters\" -Force
   Copy-Item "..\..\AKR_Training\charters\AKR_CHARTER_BACKEND.md" "docs\charters\" -Force
   
   # Copy backend templates only (NO database or UI templates)
   Copy-Item "..\..\AKR_Training\templates\backend\*" "docs\templates\" -Force
   
   # Copy backend developer guides
   Copy-Item "..\..\AKR_Training\guides\Backend_Service_Documentation_Developer_Guide.md" "docs\guides\" -Force
   Copy-Item "..\..\AKR_Training\guides\Backend_Service_Documentation_Guide.md" "docs\guides\" -Force
   ```

3. **Move existing architecture docs** to docs/architecture/:
   ```powershell
   Move-Item "architecture\*" "docs\architecture\" -Force
   ```

4. **Create documentation index**:
   - Create `docs/README.md` with table of contents
   - List all services with documentation status

5. **Document first service** (test the system):
   - Use Copilot + lean_baseline_service_template.md
   - Document CourseService
   - Create `docs/services/CourseService_doc.md`
   - Time the process (target: 20-25 minutes)

6. **Commit**:
   ```bash
   git add docs/
   git commit -m "docs: add AKR documentation system (FN99999_US###)"
   git push
   ```

---

### Phase 4: Deploy to UI Repository (Week 4)

**Goal**: Set up documentation in training-tracker-ui repo

**Steps**:

1. **Create folder structure** in training-tracker-ui:
   ```powershell
   cd "path\to\training-tracker-ui"
   
   New-Item -ItemType Directory -Path "docs\charters" -Force
   New-Item -ItemType Directory -Path "docs\templates" -Force
   New-Item -ItemType Directory -Path "docs\guides" -Force
   New-Item -ItemType Directory -Path "docs\components\common" -Force
   New-Item -ItemType Directory -Path "docs\components\courses" -Force
   New-Item -ItemType Directory -Path "docs\components\admin" -Force
   New-Item -ItemType Directory -Path "docs\pages" -Force
   New-Item -ItemType Directory -Path "docs\hooks" -Force
   New-Item -ItemType Directory -Path "docs\architecture" -Force
   ```

2. **Copy UI-SPECIFIC charters, templates, and guides** from AKR_Training:
   ```powershell
   # Copy charters (Universal + UI only)
   Copy-Item "..\..\AKR_Training\charters\AKR_CHARTER.md" "docs\charters\" -Force
   Copy-Item "..\..\AKR_Training\charters\AKR_CHARTER_UI.md" "docs\charters\" -Force
   
   # Copy UI templates only (NO database or backend templates)
   Copy-Item "..\..\AKR_Training\templates\ui\*" "docs\templates\" -Force
   
   # Copy UI developer guide only
   Copy-Item "..\..\AKR_Training\guides\UI_Component_Documentation_Developer_Guide.md" "docs\guides\" -Force
   ```

3. **Move existing architecture docs** to docs/architecture/:
   ```powershell
   Move-Item "architecture\*" "docs\architecture\" -Force
   ```

4. **Create documentation index**:
   - Create `docs/README.md` with table of contents
   - List all components with documentation status

5. **Document first component** (test the system):
   - Use Copilot + ui_component_template.md
   - Document Button component
   - Create `docs/components/common/Button_doc.md`
   - Time the process (target: 20-25 minutes)

6. **Commit**:
   ```bash
   git add docs/
   git commit -m "docs: add AKR documentation system (FN99999_US###)"
   git push
   ```

---

## Maintenance Strategy

### Keeping Charters in Sync

**Problem**: AKR_CHARTER.md copied to 3 repos. How to keep in sync?

**Solution**: AKR_Training is source of truth, manual sync as needed.

**Process**:

1. **Charter updates happen in AKR_Training** (master):
   ```bash
   cd AKR_Training
   # Edit charters/AKR_CHARTER.md
   git commit -m "docs: update AKR Charter - add new convention (FN99999_US###)"
   git push
   ```

2. **Sync to production repos** (when needed):
   ```powershell
   # Copy updated charter to database repo (POC_SpecKitProj)
   Copy-Item "C:\Users\E1481541\OneDrive - Emerson\Documents\CDS - Team Hawkeye\AKR_Training\charters\AKR_CHARTER.md" `
             "C:\Users\E1481541\OneDrive - Emerson\Documents\CDS - Team Hawkeye\AKR_Training\POC_SpecKitProj\docs\charters\" -Force
   
   cd "C:\Users\E1481541\OneDrive - Emerson\Documents\CDS - Team Hawkeye\AKR_Training\POC_SpecKitProj"
   git add docs/charters/AKR_CHARTER.md
   git commit -m "docs: sync AKR Charter from master (FN99999_US###)"
   git push
   
   # Repeat for api and ui repos (copy Universal charter only)
   # Each repo keeps its own technology-specific charter
   ```

**Frequency**: 
- Charter updates: Rare (quarterly or less)
- Sync to production repos: As needed (not every commit)
- Templates: Sync when significant improvements made

**Alternative**: Use Git submodules or symlinks (advanced).

---

### Updating Templates

**Process**:

1. **Template improvements happen in AKR_Training**:
   ```bash
   cd AKR_Training
   # Edit templates/backend/lean_baseline_service_template.md
   git commit -m "docs: improve backend template - add performance section"
   git push
   ```

2. **Copy to production repo** (optional):
   ```powershell
   # Only copy if template changes are significant
   Copy-Item "C:\path\to\AKR_Training\templates\backend\lean_baseline_service_template.md" `
             "C:\path\to\training-tracker-api\docs\templates\" -Force
   ```

**Note**: Existing documentation doesn't need to be updated when template changes. Templates are starting points, not rigid contracts.

---

### Adding New Documentation

**Workflow for developers**:

1. **Choose appropriate template** from local docs/templates/
2. **Follow charter conventions** from local docs/charters/
3. **Use Copilot + developer guide** from local docs/guides/
4. **Create documentation** in appropriate docs/ subfolder
5. **Update README.md** index with new entry
6. **Create PR** with feature tag

**Example** (documenting new table in POC_SpecKitProj):
```bash
cd "C:\Users\E1481541\OneDrive - Emerson\Documents\CDS - Team Hawkeye\AKR_Training\POC_SpecKitProj"

# Copy template to new file
Copy-Item "docs\templates\table_doc_template.md" "docs\tables\NewTable_doc.md"

# Use Copilot to generate baseline (see developer guide)
# Enhance with human context
# Review and validate

# Update index
# Edit docs/README.md, add NewTable to table list

# Commit
git add docs/tables/NewTable_doc.md
git add docs/README.md
git commit -m "docs: add NewTable documentation (FN99999_US###)"
git push
```

---

## Optional: Knowledge Domain Repository

**Purpose**: Central location for cross-cutting documentation

**When to use**:
- Architecture decisions that span all repos
- Cross-repo integration documentation
- System-wide patterns and conventions
- Onboarding documentation

**Structure**:

```
knowledge-domain-repo/
├── README.md
│
├── architecture/
│   ├── system-overview.md                      ← High-level system architecture
│   ├── deployment-architecture.md              ← Deployment topology
│   ├── data-flow.md                            ← Data flow across repos
│   └── integration-patterns.md                 ← How repos integrate
│
├── patterns/
│   ├── authentication-pattern.md               ← Auth across UI, API, DB
│   ├── error-handling-pattern.md               ← Consistent error handling
│   └── logging-pattern.md                      ← Logging standards
│
├── onboarding/
│   ├── developer-onboarding.md                 ← New dev guide
│   ├── repo-setup.md                           ← How to clone and run
│   └── documentation-guide.md                  ← How to use AKR system
│
├── decisions/
│   ├── ADR-001-database-choice.md              ← Architecture Decision Records
│   ├── ADR-002-frontend-framework.md
│   └── ADR-003-api-architecture.md
│
└── glossary/
    └── business-glossary.md                    ← Business terms and definitions
```

**Benefits**:
- ✅ Single source for cross-cutting concerns
- ✅ Clear separation: Code repos have technical docs, KD repo has architectural docs
- ✅ Easier to onboard new developers

**Drawbacks**:
- ❌ Another repo to maintain
- ❌ Adds complexity

**Recommendation**: Start without KD repo. Add later if cross-cutting docs accumulate.

---

## Success Metrics

### After 1 Month

**AKR_Training** (Master Repo):
- ✅ Reorganized folder structure
- ✅ All charters, templates, guides in clear locations
- ✅ Documentation index files created

**Database Repo**:
- ✅ Docs folder structure created
- ✅ 5+ tables documented
- ✅ Documentation referenced in technical discussions

**API Repo**:
- ✅ Docs folder structure created
- ✅ 3+ services documented
- ✅ Architecture docs moved to docs/

**UI Repo**:
- ✅ Docs folder structure created
- ✅ 3+ components documented
- ✅ Architecture docs moved to docs/

---

### After 3 Months

- ✅ 90%+ critical tables/services/components documented
- ✅ Documentation used in onboarding (new dev references docs)
- ✅ Charters refined based on experience
- ✅ Team comfortable with system
- ✅ Average documentation time: <30 min per object

---

### After 6 Months

- ✅ Documentation system self-sustaining
- ✅ New objects documented automatically
- ✅ Cross-repo references working smoothly
- ✅ Demonstrable value (onboarding time reduction, fewer support escalations)
- ✅ Consider expanding to other projects

---

## Summary

### Recommended Structure (TL;DR)

**Master Repository** (AKR_Training):
```
charters/         ← All 4 charters (Universal, DB, Backend, UI)
templates/        ← All templates (Database, Backend, UI)
guides/           ← All developer guides
features/         ← Business/functional documentation (NEW)
  ├── courses/    ← Course-related features
  ├── users/      ← User-related features
  ├── enrollments/← Enrollment-related features
  ├── admin/      ← Admin features
  ├── dashboard/  ← Dashboard features
  └── cross-cutting/  ← Cross-domain features (auth, logging, etc.)
assessments/      ← Assessment documents
examples/         ← Example documentation
**Current POC Repositories** (within AKR_Training):
```
POC_SpecKitProj/  ← Database SSDT project
backend/          ← Backend API
training-tracker-ui/ ← UI
```

**Each POC Repository Gets**:
```
docs/
├── charters/     ← Universal charter + technology-specific charter ONLY
│                   (Database: AKR_CHARTER.md + AKR_CHARTER_DB.md)
│                   (API: AKR_CHARTER.md + AKR_CHARTER_BACKEND.md)
│                   (UI: AKR_CHARTER.md + AKR_CHARTER_UI.md)
├── templates/    ← Technology-specific templates ONLY
│                   (NO cross-technology templates)
├── guides/       ← Technology-specific guide ONLY
│                   (Database team sees DB guide, Backend team sees Backend guide, etc.)
├── [type]/       ← Documentation (tables/, services/, components/)
├── architecture/ ← Architecture docs
└── README.md     ← Documentation index
```

**Key Principles**: 
1. Each repository is **self-contained** for its technology area (Database developers don't see backend templates, UI developers don't see database templates, etc.)
2. **Two-tier documentation**: Technical docs in repos (developer-focused), Feature docs in AKR_Training (business-focused)

**Cross-Repo Linking**: Use relative paths within AKR_Training or GitHub/Azure DevOps URLs if split into separate repos

**Maintenance**: AKR_Training is source of truth, sync to production repos as needed

**Migration**: 4-week phased rollout (Master → DB → API → UI)

**Feature Documentation**: See [Feature Documentation Strategy](FEATURE_DOCUMENTATION_STRATEGY.md) for complete guide on consolidating business/functional requirements

---

## Next Steps

### Phase 1: Technical Documentation System (Weeks 1-4)
1. **Week 1**: Reorganize AKR_Training folder structure (including features/ folder)
2. **Week 2**: Deploy to POC_SpecKitProj database, document 5 tables
3. **Week 3**: Deploy to backend API, document 3 services
4. **Week 4**: Deploy to training-tracker-ui, document 3 components

### Phase 2: Feature Documentation System (Weeks 5-8)
5. **Week 5**: Create feature documentation template, define RACI matrix
6. **Week 6-7**: Pilot with 1-2 features, train team on process
7. **Week 8**: Document 5-10 features, establish post-sprint consolidation rhythm

### Phase 3: Refinement (Month 3+)
8. **Month 3+**: Continue documenting, refine based on experience, scale to other projects

**See Also**: [Feature Documentation Strategy](FEATURE_DOCUMENTATION_STRATEGY.md) for detailed feature documentation workflow

---

**Questions?** Review this document, check AKR_CHARTER.md, or ask team lead.

---

**AKR Folder Structure Recommendation - End of Document**
