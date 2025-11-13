# AKR System Files - Summary

**Date**: 2025-10-22  
**System**: Application Knowledge Repo (AKR)

---

## What Was Created

Three files have been created for your **Application Knowledge Repo (AKR)** documentation system:

### 1. **AKR_CHARTER.md** - Universal Principles
**Size**: ~800 lines  
**Purpose**: System-wide governing document that applies to ALL documentation

**Contains**:
- ✅ Core principles (Lean, Flexible, Evolutionary, Tool-Assisted, Git-Integrated)
- ✅ Universal conventions (generic data types, feature tags, file naming, Git format)
- ✅ Documentation tiers (Essential/Recommended/Optional)
- ✅ Tool integration guidance (LLM prompts, Python scripts)
- ✅ Common patterns (Business Rules format, Database-Specific Features)
- ✅ Governance model (how Charter evolves, team customization)

**Audience**: All developers, all teams, all documentation types

---

### 2. **AKR_CHARTER_DB.md** - Database-Specific Conventions
**Size**: ~700 lines  
**Purpose**: Extends universal Charter with database-specific guidance

**Contains**:
- ✅ Database object naming (tables, views, SPs, functions, schemas)
- ✅ Column naming patterns (PK, FK, booleans, dates, audit columns)
- ✅ Constraint naming conventions (PK, FK, Unique, Check, Default, Index)
- ✅ Documentation structure for database objects
- ✅ Database-specific patterns (constraints, indexes, triggers, migrations)
- ✅ Schema organization best practices
- ✅ Performance and security documentation guidance

**Audience**: Database developers, DBAs, anyone documenting database objects

---

### 3. **table_doc_template.md** - Updated Table Documentation Template
**Size**: ~400 lines (leaner than before)  
**Purpose**: Template for documenting database tables

**Changes from previous version**:
- ✅ References AKR_CHARTER.md for universal conventions (no duplication)
- ✅ References AKR_CHARTER_DB.md for database patterns (no duplication)
- ✅ Cleaner structure (removed embedded conventions)
- ✅ Clearer guidance on what's required vs. optional
- ✅ Integrated with AKR system

**Audience**: Developers documenting tables

---

## How They Work Together

### File Hierarchy

```
AKR_CHARTER.md (Universal - applies to everything)
    ↓ Extended by
AKR_CHARTER_DB.md (Database-specific - applies to database objects)
    ↓ Referenced by
table_doc_template.md (Table-specific - structure for tables)
    ↓ Customized by (optional)
OUR_STANDARDS.md (Team-specific - your team's requirements)
    ↓ Used by
Developers (generate and maintain documentation)
```

### Content Separation

| File | What It Contains | What It Doesn't Contain |
|------|------------------|------------------------|
| **AKR_CHARTER.md** | Principles, universal conventions, shared patterns | Template-specific structure, database details |
| **AKR_CHARTER_DB.md** | Database naming, patterns, conventions | Universal principles (references Charter), table structure |
| **table_doc_template.md** | Table documentation structure and sections | Conventions (references Charters), detailed guidance |

**Result**: No duplication. Change once, applies everywhere.

---

## Key Design Decisions

### 1. "Application Knowledge Repo" (AKR)

**Why this name**:
- ✅ Modern (aligns with Git "repo" concept)
- ✅ Clear (knowledge about applications)
- ✅ No collision (unlike AKS = Azure Kubernetes Service)
- ✅ Memorable acronym
- ✅ Scalable (AKR_CHARTER_DB, AKR_CHARTER_UI, AKR_CHARTER_API)

---

### 2. No "Change History" Sections

**Rationale**:
- Git is authoritative source for change history
- Git commit messages show what changed and when
- Git log provides complete timeline
- Embedding history in docs creates redundancy
- Reduces maintenance burden

**How to view history**:
```bash
git log docs/tables/Courses_doc.md
git log -p docs/tables/Courses_doc.md  # with diffs
git log --grep="FN99999" docs/tables/Courses_doc.md  # search
```

---

### 3. Generic Data Types

**Universal convention**: Use generic types, note native types

**Examples**:
- `Id` (GUID, Required) - Primary key (native: UNIQUEIDENTIFIER)
- `IsActive` (Boolean, Required) - Status flag (native: BIT)

**Why**:
- Portability (easier to migrate databases)
- Clarity (generic types are self-explanatory)
- Consistency (same vocabulary across all docs)

**Mapping table in AKR_CHARTER.md** covers SQL Server, PostgreSQL, MySQL.

---

### 4. Feature Tag Convention

**Format**: `FN#####_US#####`

**Usage**:
```bash
git commit -m "docs: add Courses table documentation (FN99999_US002)"
```

**Purpose**: Links documentation to Azure Boards work items for traceability.

---

### 5. Documentation Tiers

**Tier 1: Essential** (always required)
- Table identification, Purpose, Columns

**Tier 2: Recommended** (include when applicable)
- Constraints, Business Rules, Related Objects

**Tier 3: Optional** (add when valuable)
- External Integrations, Performance, Limitations, etc.

**Philosophy**: Start lean, add as knowledge accumulates.

---

### 6. Tool-Assisted, Human-Verified

**Workflow**:
1. LLM or Python script generates 60-70% (structure, inferred content)
2. Developer adds 30-40% (business context, custom sections)
3. Tech Lead reviews (accuracy, value, usefulness)
4. Approved → Merge

**Why**: Automation accelerates, humans ensure accuracy.

---

## Where to Put These Files

### Recommended Structure

**Option A: All in Knowledge Domain Repository (KDRepo)**
```
KDRepo/
├── AKR_CHARTER.md
├── AKR_CHARTER_DB.md
├── AKR_CHARTER_UI.md (future)
├── AKR_CHARTER_API.md (future)
├── templates/
│   ├── table_doc_template.md
│   ├── view_doc_template.md (future)
│   └── sp_doc_template.md (future)
├── docs/
│   └── tables/
│       ├── Courses_doc.md
│       ├── Users_doc.md
│       └── Enrollments_doc.md
└── OUR_STANDARDS_EXAMPLE.md
```

**Pro**: Single source of truth, easier to maintain  
**Con**: Database repo references external KDRepo

---

**Option B: Charters in Each Repository**
```
Database-Repository/
├── AKR_CHARTER.md (symlink or copy)
├── AKR_CHARTER_DB.md (local)
├── templates/
│   └── table_doc_template.md
└── docs/
    └── tables/
        ├── Courses_doc.md
        └── Users_doc.md

UI-Repository/
├── AKR_CHARTER.md (symlink or copy)
├── AKR_CHARTER_UI.md (local - future)
└── [UI docs]

API-Repository/
├── AKR_CHARTER.md (symlink or copy)
├── AKR_CHARTER_API.md (local - future)
└── [API docs]
```

**Pro**: Documentation co-located with code  
**Con**: Must sync AKR_CHARTER.md across repos

---

**Recommendation**: Start with **Option A** (KDRepo), migrate to Option B if co-location becomes important.

---

## Next Steps

### Immediate (This Week)

1. ✅ **Download the three files**
   - AKR_CHARTER.md
   - AKR_CHARTER_DB.md
   - table_doc_template.md (updated)

2. ✅ **Add to your repository**
   ```bash
   # Create directory structure
   mkdir -p docs/templates
   
   # Move files
   mv AKR_CHARTER.md docs/
   mv AKR_CHARTER_DB.md docs/
   mv table_doc_template.md docs/templates/
   
   # Commit
   git add docs/
   git commit -m "docs: add AKR Charter system (FN99999_US###)"
   git push
   ```

3. ✅ **Test with Training Tracker**
   - Document Courses table using template
   - Verify LLM generation works with Charter references
   - Time the process (should be 15-30 minutes)

---

### Short-Term (Next 2 Weeks)

4. **Document remaining Training Tracker tables**
   - Users
   - Enrollments
   - CourseCategories (if exists)
   - CoursePrerequisites (if exists)

5. **Create team standards** (optional)
   - Copy OUR_STANDARDS_EXAMPLE.md → OUR_STANDARDS.md
   - Customize for your team's specific requirements
   - Define what's required vs. recommended for your context

6. **Gather feedback**
   - Is Charter clear and useful?
   - Are conventions easy to follow?
   - Is template sufficient?
   - What's missing or confusing?

---

### Medium-Term (Next Month)

7. **Create additional templates** (as needed)
   - view_doc_template.md (for views)
   - sp_doc_template.md (for stored procedures)
   - Each references AKR_CHARTER.md and AKR_CHARTER_DB.md

8. **Expand to other projects** (if successful)
   - Introduce AKR system to other teams
   - Create UI/API charters (AKR_CHARTER_UI.md, AKR_CHARTER_API.md)
   - Share learnings across teams

9. **Iterate based on experience**
   - Refine Charter based on real usage
   - Update conventions if they don't work
   - Add missing patterns discovered in practice

---

### Long-Term (6+ Months)

10. **Validation scripts** (optional)
    - Create validation script that checks AKR compliance
    - Integrate into CI/CD
    - Automated checks for required sections, format conventions

11. **Metrics tracking** (optional)
    - Documentation coverage (% of tables documented)
    - Time investment (hours per table)
    - Usage metrics (documentation references in discussions)
    - Value metrics (onboarding time reduction)

12. **Domain documentation consolidation** (Script #2)
    - Python script that aggregates technical references
    - Consolidates into domain-level documentation
    - See original doc_system_summary.txt for Script #2 design

---

## Common Questions

### Q: Can I customize the Charter?

**A**: Yes, but carefully.
- ✅ Add team-specific extensions in OUR_STANDARDS.md
- ✅ Propose Charter changes via PR (cross-team discussion)
- ❌ Don't contradict Charter in team standards

### Q: Do I need all optional sections?

**A**: No! Add them when they provide value.
- Day 1: Essential sections only
- Month 3: Add "Known Limitations" after production issues
- Month 6: Add "External Integrations" when mobile app integrates

### Q: What if LLM generates wrong information?

**A**: Expected. Review and correct.
- LLMs generate structure + inferred content (60-70%)
- You add accuracy + business context (30-40%)
- Tech Lead verifies before merge

### Q: Can I skip feature tags?

**A**: No. Feature tags are required per Charter.
- Links documentation to work items (traceability)
- Enables metrics and reporting
- Git history shows feature evolution

### Q: What if my table doesn't fit the template?

**A**: Customize! Template is starting point.
- Add custom sections as needed
- Remove sections that don't apply (if truly not applicable)
- Document what helps your team

---

## Files Summary

| File | Size | Purpose | Update Frequency |
|------|------|---------|------------------|
| AKR_CHARTER.md | ~800 lines | Universal principles | Rare (quarterly) |
| AKR_CHARTER_DB.md | ~700 lines | Database conventions | Occasional (monthly) |
| table_doc_template.md | ~400 lines | Table structure | Rare (when patterns change) |
| OUR_STANDARDS.md | Varies | Team requirements | Frequent (weekly/monthly) |

---

## Success Metrics

**After 1 month**:
- ✅ 5+ tables documented
- ✅ Team familiar with workflow
- ✅ Documentation references in technical discussions
- ✅ Average time <30 min per table

**After 3 months**:
- ✅ 90%+ core tables documented
- ✅ Documentation used in onboarding
- ✅ Charters refined based on experience
- ✅ Team comfortable with system

**After 6 months**:
- ✅ Documentation system self-sustaining
- ✅ New tables documented automatically
- ✅ Demonstrable value (onboarding time reduction, fewer support escalations)
- ✅ Expand to other projects if successful

---

## Support

**Questions about AKR system?**
- Read AKR_CHARTER.md for principles
- Read AKR_CHARTER_DB.md for database patterns
- Check template for structure guidance
- Ask team lead or architecture team

**Proposing improvements?**
- Open PR with rationale
- Tag relevant stakeholders
- Discuss impact across teams

**Need examples?**
- Check existing table documentation
- Look at Training Tracker docs (once created)
- Ask team members for guidance

---

## Philosophy Reminder

**The AKR system is built on these beliefs**:

1. **Documentation should help, not hinder**
2. **Developers are intelligent** (trust them to customize)
3. **Context varies** (one size doesn't fit all)
4. **Knowledge accumulates** (docs grow as we learn)
5. **Tools assist** (but humans provide judgment)
6. **Quality > compliance** (useful imperfect > perfect useless)

**If documentation isn't being referenced, it's not providing value.**

---

**Ready to start documenting!** 🚀

Download the three files and add them to your repository. Test with your Training Tracker tables. Iterate based on what you learn.

**Good luck!**
