# Service: [SERVICE_NAME]

**Namespace/Project**: [Project.Services]  
**File Location**: `src/Services/[ServiceName].cs`  
**Last Updated**: [YYYY-MM-DD]  
**Complexity**: [Simple / Medium / Complex]  
**Documentation Level**: 🔶 Baseline (70% complete)

---

## Quick Reference (TL;DR)

**What it does:**  
🤖 [AI: 1-2 sentences on what service accomplishes]  
❓ [HUMAN: Add business value - why does this service exist?]

**When to use it:**  
❓ [HUMAN: What scenarios trigger use of this service? Web UI? API? Background jobs?]

**Watch out for:**  
❓ [HUMAN: Critical gotcha or common mistake when using this service]

---

## What & Why

### Purpose

🤖 [AI: Technical description of what service does]

❓ [HUMAN: Business purpose - what problem does this solve? Why did we build it?]

### Capabilities

🤖 [AI: Bullet list of what service can do]

**Example:**
- Enroll users in courses with prerequisite validation
- Check enrollment eligibility based on business rules
- Send enrollment confirmation emails
- Track enrollment history

### Not Responsible For

🤖 [AI: What this service explicitly does NOT do]  
❓ [HUMAN: Clarify scope boundaries - what's handled elsewhere?]

**Example:**
- Does NOT handle payment processing (handled by PaymentService)
- Does NOT validate user authentication (handled by AuthService)
- Does NOT manage course catalog (handled by CourseService)

---

## How It Works

### Primary Operation: [Main Method Name]

**Purpose:**  
🤖 [AI: What this method accomplishes]  
❓ [HUMAN: Business context - why do we need this operation?]

**Input:**  
🤖 [AI: Parameters and types]

**Output:**  
🤖 [AI: Return type and success/failure scenarios]

**Step-by-Step Flow:**

```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: [Action]                                             │
│  What  → 🤖 [AI: Technical action taken]                     │
│  Why   → ❓ [HUMAN: Business reason for this step]           │
│  Error → 🤖 [AI: What errors can occur]                      │
│         ❓ [HUMAN: Business impact of error]                 │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 2: [Action]                                             │
│  What  → 🤖 [AI: Technical action taken]                     │
│  Why   → ❓ [HUMAN: Business reason for this step]           │
│  Error → 🤖 [AI: What errors can occur]                      │
│         ❓ [HUMAN: Business impact of error]                 │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 3: [Action]                                             │
│  What  → 🤖 [AI: Technical action taken]                     │
│  Why   → ❓ [HUMAN: Business reason for this step]           │
│  Error → 🤖 [AI: What errors can occur]                      │
│         ❓ [HUMAN: Business impact of error]                 │
└─────────────────────────────────────────────────────────────┘
                          ↓
                    [SUCCESS] or [FAILURE]
```

**Success Path:**  
🤖 [AI: What happens on successful completion]

**Failure Paths:**  
🤖 [AI: What errors can occur and when]  
❓ [HUMAN: Business implications of each failure]

---

## Business Rules

[Table of business rules enforced by this service]

| Rule ID | Description | Why It Exists | Since When |
|---------|-------------|---------------|------------|
| 🤖 **BR-[SVC]-001** | 🤖 [AI: Rule description from code] | ❓ [HUMAN: Business rationale] | ❓ [HUMAN: When added] |
| 🤖 **BR-[SVC]-002** | 🤖 [AI: Rule description from code] | ❓ [HUMAN: Business rationale] | ❓ [HUMAN: When added] |
| 🤖 **BR-[SVC]-003** | 🤖 [AI: Rule description from code] | ❓ [HUMAN: Business rationale] | ❓ [HUMAN: When added] |

**Rule ID Format:** BR-[ServiceAbbreviation]-### (e.g., BR-ENR-001 for EnrollmentService)

**Common Questions:**
- ❓ [HUMAN: Any rules that seem arbitrary? Document the history.]
- ❓ [HUMAN: Any rules that changed recently? Document why.]

---

## Architecture

### Where This Fits

```
┌──────────────────────┐
│   API Layer          │  🤖 [AI: Controller name]
│   (Entry Point)      │  → See API Reference Database:
│                      │     [Link to API docs]
└──────────────────────┘
           ↓
┌──────────────────────┐
│   ► THIS SERVICE ◄   │  [ServiceName]
│   (Business Logic)   │  🤖 [AI: Purpose]
└──────────────────────┘
           ↓
┌──────────────────────┐
│   Data Layer         │  🤖 [AI: Repository name]
│   (Database Access)  │  → Operates on: [Table names]
└──────────────────────┘
```

### Dependencies (What This Service Needs)

| Dependency | Purpose | Failure Mode |
|------------|---------|--------------|
| 🤖 `IDependencyName` | 🤖 [AI: What it's used for] | ❓ [HUMAN: Critical? Blocking? Non-blocking?] |
| 🤖 `IDependencyName` | 🤖 [AI: What it's used for] | ❓ [HUMAN: What happens if unavailable?] |

### Consumers (Who Uses This Service)

| Consumer | Use Case | Impact of Failure |
|----------|----------|-------------------|
| 🤖 [Controller/Service name] | 🤖 [AI: How they use it] | ❓ [HUMAN: User-facing? Background?] |
| 🤖 [Controller/Service name] | 🤖 [AI: How they use it] | ❓ [HUMAN: What breaks if this fails?] |

---

## Data Operations

### Reads From

| Table/Source | Purpose | Business Context |
|--------------|---------|------------------|
| 🤖 `schema.TableName` | 🤖 [AI: What data retrieved] | ❓ [HUMAN: Why needed?] |
| 🤖 `schema.TableName` | 🤖 [AI: What data retrieved] | ❓ [HUMAN: Why needed?] |

**Cross-Repository Reference:**  
For table schema details, see [Table Documentation](../../database-repo/docs/tables/)

### Writes To

| Table/Destination | Operation | Business Purpose |
|-------------------|-----------|------------------|
| 🤖 `schema.TableName` | 🤖 [AI: INSERT/UPDATE/DELETE] | ❓ [HUMAN: What business event?] |
| 🤖 `schema.TableName` | 🤖 [AI: INSERT/UPDATE/DELETE] | ❓ [HUMAN: What business event?] |

### Side Effects

| Side Effect | When | Blocking? |
|-------------|------|-----------|
| 🤖 Email notification | 🤖 [AI: After what action] | ❓ [HUMAN: Async? Must succeed?] |
| 🤖 Audit log entry | 🤖 [AI: After what action] | ❓ [HUMAN: Async? Must succeed?] |
| 🤖 Cache invalidation | 🤖 [AI: After what action] | ❓ [HUMAN: Async? Must succeed?] |

---

## Questions & Gaps

### AI-Flagged Questions

🤖 [AI will identify unclear logic, magic numbers, assumptions]

**Example:**
- 🤖 Magic number "3" in validation - purpose unclear
- 🤖 Hardcoded timeout value - should be configurable?
- 🤖 Comment says "temporary workaround" - what's the permanent fix?

### Human-Flagged Questions

❓ [HUMAN: Add questions you have while reviewing]

**Example:**
- ❓ Why does prerequisite validation happen twice?
- ❓ Who decided the 3-enrollment limit and why?
- ❓ Should we notify admin when enrollment fails?

### Next Steps

- [ ] ❓ [HUMAN: Follow-up actions needed]
- [ ] ❓ [HUMAN: People to ask for clarification]
- [ ] ❓ [HUMAN: Documentation to reference]

---

## Optional Sections (Add When Needed)

The sections below are **OPTIONAL**. Add them only when you have real information to share:

### Alternative Paths (Add When: Complex conditional logic)

[Document alternative flows beyond primary operation]

### Performance (Add When: Production metrics available)

[Document response times, bottlenecks, optimization notes]

### Known Issues & Limitations (Add When: Bugs or workarounds exist)

[Document current limitations, technical debt, workarounds]

### External Dependencies (Add When: Third-party integrations)

[Document external systems, APIs, failure behavior]

### Common Problems & Solutions (Add When: Support tickets occur)

[Document recurring issues and how to resolve them]

### What Could Break (Add When: Planning major changes)

[Document downstream impacts of changing this service]

---

## Maintenance Checklist

**When making code changes to this service:**

- [ ] Update this documentation if behavior changes
- [ ] Update business rules table if validation logic changes
- [ ] Update flow diagram if steps added/removed
- [ ] Update error reference if new errors introduced
- [ ] Add to "Known Issues" if introducing limitation
- [ ] Update "Questions & Gaps" if answering previous questions

---

## Documentation Standards

This template follows the **Lean Baseline Service Documentation** approach:
- 70% generated by AI (Copilot/ChatGPT) - marked with 🤖
- 30% human-enhanced business context - marked with ❓
- Baseline sections required (~20-25 minutes)
- Optional sections added when triggered by events

**Baseline Sections (Required):**
- Quick Reference, What & Why, How It Works, Business Rules
- Architecture, Data Operations, Questions & Gaps

**Optional Sections (Add Later):**
- Alternative Paths, Performance, Known Issues, External Dependencies
- Common Problems, What Could Break

See `Backend_Service_Documentation_Guide.md` for complete implementation guide.

---

## AI Generation Instructions

**For AI (Copilot/ChatGPT):**

When generating this documentation:
1. Mark all AI-generated content with 🤖
2. Mark sections needing human input with ❓
3. Extract method signatures, parameters, return types from code
4. Identify dependencies from constructor injection
5. List database tables from repository calls
6. Extract validation logic for business rules
7. Flag magic numbers, hardcoded values, unclear logic
8. Create text-based flow diagram (NOT Mermaid)
9. Focus on WHAT code does (observable behavior)
10. Flag WHY questions for human input (cannot infer business context)

**For Humans:**

After AI generates baseline:
1. Add business context to "Why" fields (5 min)
2. Complete business rules "Why It Exists" column (5 min)
3. Add failure modes to dependencies (3 min)
4. Complete Quick Reference usage scenarios (3 min)
5. Answer Questions & Gaps items you can (2 min)
6. Review flow diagram for accuracy (2 min)

**Total Time:** 20-25 minutes

---

## Documentation Standards

### This template follows the Application Knowledge Repo (AKR) system

**For universal conventions, see**:
- **AKR_CHARTER.md** - Core principles, generic data types, feature tags, Git format
  - Why we document (lean, flexible, evolutionary)
  - Universal conventions (all documentation types)
  - Documentation tiers (Essential/Recommended/Optional)
  - Tool integration (LLM assistance, Git workflows)

**For backend service-specific conventions, see**:
- **AKR_CHARTER_BACKEND.md** - Service layer naming, documentation patterns, enterprise best practices
  - Service naming conventions (classes, methods, files)
  - Service documentation structure (baseline vs optional sections)
  - Business rules format (BR-[SVC]-### convention)
  - Flow diagram patterns (text-based boxes with What/Why/Error/Impact)
  - Dependencies and consumers documentation
  - Data operations patterns
  - Enterprise best practices (separation of concerns, DI, async/await, transactions, logging, validation)
  - AI-assisted workflow (Human/AI responsibility split)
  - Common anti-patterns to avoid

**For team-specific requirements, see**:
- **OUR_STANDARDS.md** (if exists in your project)
  - Team-specific required sections
  - Team-specific formats
  - Validation rules
  - Custom conventions

---

## Minimum Viable Documentation

**Essential sections** (must include):
- Service identification (name, namespace, file location, last updated)
- Quick Reference (what it does, when to use, watch out for)
- What & Why (purpose, capabilities, scope boundaries)
- Primary Operation (main method flow with inputs/outputs)

**That's it!** Everything else is recommended or optional.

Start lean, add detail as knowledge accumulates.

---

## Recommended Sections (Include When Applicable)

Add these sections when the information is relevant:
- Business Rules (if validation/business logic exists)
- Architecture (if dependencies or consumers are important)
- Data Operations (if database interactions exist)
- Questions & Gaps (flag unknowns for future clarification)

---

## Optional Sections (Add When Valuable)

The sections below are optional. Add them when you have real information to share, not on Day 1 with placeholder text:

### Alternative Paths
[Document when: Service has complex conditional logic, multiple workflows]

### Performance Considerations
[Document when: Production metrics available, bottlenecks identified]

### Known Issues & Limitations
[Document when: Bugs discovered, workarounds implemented, technical debt exists]

### External Dependencies
[Document when: Third-party API integrations, external systems]

### Common Problems & Solutions
[Document when: Support tickets, production incidents, recurring issues]

### What Could Break
[Document when: Planning major refactoring, assessing downstream impact]

### Security & Authorization
[Document when: Special security requirements, sensitive data handling]

### Testing Guidance
[Document when: Complex test setup, integration test patterns needed]

**Remember**: Add optional sections when they help the team, not because a template suggests them.

---

## Related Documentation

**API Endpoints:** See API Reference Database: [Link to your API docs system]  
**Database Tables:** See database documentation:
- Cross-repository format: `[Table Name](../../database-repo/docs/tables/TableName_doc.md)`
- Same repository format: `[Table Name](../database/tables/TableName_doc.md)`

**Related Services:** Link to dependent/consumer service docs:
- `[ServiceName](./ServiceName_doc.md)`

---

## Change History

**Service evolution is tracked in Git**, not in this document.

To see how this service evolved:
```bash
# View all changes to this documentation file
git log docs/services/[ServiceName]_doc.md

# View changes with diffs
git log -p docs/services/[ServiceName]_doc.md

# Search for specific business rule or feature
git log --grep="BR-[SVC]" docs/services/[ServiceName]_doc.md
git log --grep="FN#####" docs/services/[ServiceName]_doc.md
```

**Include feature tags in commit messages** to link documentation changes to work items:
```bash
git commit -m "docs: update [ServiceName] - add prerequisite validation (FN12345_US067)"
```

See AKR_CHARTER.md for complete Git conventions.

---

## How to Use This Template

### Step 1: Generate Initial Structure

**Option A: Using Copilot** (GitHub Copilot, recommended)
```
Open Copilot Chat (Ctrl+Shift+I):

"Follow AKR_CHARTER.md and AKR_CHARTER_BACKEND.md conventions.
Use this template at lean_baseline_service_template.md to generate 
documentation for the following service:

[Attach service file, repository files, related DTOs]

Include ONLY baseline sections (skip optional sections):
- Service Identification
- Quick Reference (TL;DR)
- What & Why
- Primary Operation (with text-based flow diagram)
- Business Rules (table with Why It Exists column)
- Architecture (Dependencies and Consumers)
- Data Operations (Reads, Writes, Side Effects)
- Questions & Gaps

Mark AI-generated content with 🤖
Mark sections needing human input with ❓
Use text-based flow diagrams (NOT Mermaid)
Focus on WHAT code does (AI extracts from code)
Flag WHY questions for human input (business context)"
```

**Option B: Using ChatGPT/Claude**
- Copy service file content
- Paste prompt similar to above
- Include references to AKR charters
- Copy generated documentation to template

**Option C: Manual** (not recommended for baseline - too time-consuming)
- Copy template
- Fill in each section manually
- Use template structure as guide

### Step 2: Review and Enhance

After AI generates baseline documentation:

**Human enhancement (20-25 minutes):**
- [ ] Add business context to "Why" fields (5 min)
  - Why does this service exist?
  - What business problem does it solve?
- [ ] Complete business rules "Why It Exists" column (5 min)
  - Business rationale for each rule
  - Regulatory requirements if applicable
- [ ] Add failure modes to dependencies (3 min)
  - Critical vs non-critical dependencies
  - What happens if dependency unavailable
- [ ] Complete Quick Reference usage scenarios (3 min)
  - When to use this service
  - Common mistakes/gotchas
- [ ] Answer Questions & Gaps items you can (2 min)
  - Remove answered questions
  - Add new questions you discover
- [ ] Review flow diagram for accuracy (2 min)
  - Verify technical steps correct
  - Add business context to Why fields

**Total Time:** 20-25 minutes for production-ready baseline

### Step 3: Submit for Review

```bash
git add docs/services/[ServiceName]_doc.md
git commit -m "docs: add [ServiceName] baseline documentation (FN#####_US#####)

- Generated baseline using Copilot
- Enhanced with business context
- Documented business rules with rationale
- Identified dependencies and consumers
"
# Create PR, request Tech Lead review
```

### Step 4: Tech Lead Review

**Tech Leads evaluate**:
- ✅ Is this useful for the team?
- ✅ Is the content accurate?
- ✅ Is business context included (WHY, not just WHAT)?
- ✅ Are business rules documented with rationale?
- ✅ Does it follow AKR conventions?

**Not evaluated**: Perfect grammar, exact template match, exhaustive detail

**Acceptance criteria**: Documentation helps developers understand service without reading all code.

---

## Quick Reference for Service Documentation

### Required Conventions (from AKR Charters)

**Service Naming** (see AKR_CHARTER_BACKEND.md):
- Class: `[Entity]Service` or `[Capability]Service`
- Methods: `Verb[Entity][Qualifier]` (e.g., `EnrollUserInCourse`, `GetActiveCourses`)
- Async: Suffix with `Async` (C#) or use `async` keyword (JS/TS/Python)

**Business Rules Format** (see AKR_CHARTER_BACKEND.md):
- Format: `BR-[ServiceAbbreviation]-###: Rule description`
- Example: `BR-ENR-001: Users cannot enroll in same course twice`
- Always include "Why It Exists" column (business rationale)

**Feature Tag Format** (see AKR_CHARTER.md):
- Format: `FN#####_US#####`
- Use in commit messages

**Flow Diagrams** (see AKR_CHARTER_BACKEND.md):
- Text-based boxes (NOT Mermaid)
- Include: What (technical), Why (business), Error (exceptions), Impact (consequence)

**AI/Human Markers**:
- 🤖 = AI-generated content (WHAT code does)
- ❓ = Needs human input (WHY decisions, business context)

### Time Estimates

- **AI generation**: 5-7 minutes
- **Human enhancement**: 18-20 minutes
- **Total baseline**: ~25 minutes
- **Optional section**: +10-15 minutes each (add later when triggered)

### Getting Help

**Questions about template?**
- Check AKR_CHARTER.md for principles
- Check AKR_CHARTER_BACKEND.md for service patterns
- Check Backend_Service_Documentation_Guide.md for detailed workflow
- Check OUR_STANDARDS.md for team specifics
- Ask Tech Lead or team channel

**AI generated wrong info?**
- Normal - LLMs hallucinate. Review and correct.
- Focus on structure + inferred content, you add accuracy + business context

**Service too complex for baseline?**
- Start with baseline (70% complete)
- Add optional sections incrementally
- Don't try to document everything upfront
- Document what you know now, expand as you learn

---

## Template Metadata

**Template Version**: Lean Baseline v1.0  
**Last Updated**: 2025-10-31  
**Maintained By**: Architecture Team  
**Part of**: Application Knowledge Repo (AKR) system

**Time to Complete**: 20-25 minutes (with AI assistance)  
**Best For**: 80% of services, legacy documentation, sustainable at scale  
**Documentation Level**: 🔶 70% complete baseline (production-ready)

**Previous Version**: N/A (initial version)  
**Key Philosophy**: AI generates structure (WHAT), humans add context (WHY)

---

**Pro tip:** Focus on capturing business context (WHY), not rehashing code (WHAT). The code already says WHAT it does - documentation should explain WHY it does it that way.
