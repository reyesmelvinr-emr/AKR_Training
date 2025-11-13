# Enterprise System Overview

[← Back to Enterprise Architecture](../../ARCHITECTURE_ENTERPRISE_RECOMMENDED.md)

---

## Purpose

This document outlines the recommended enterprise architecture for deploying the Training Tracker application to production. It addresses scalability, security, reliability, and operational requirements for supporting hundreds to thousands of users in a business-critical environment.

---

## System Context - Enterprise View

### Stakeholders

| Stakeholder Group | Needs | Count |
|-------------------|-------|-------|
| **Employees** | View training, enroll in courses, track completion | 1000-5000 |
| **Managers** | Monitor team compliance, assign training | 100-500 |
| **Administrators** | Manage courses, users, system config | 5-20 |
| **HR Department** | Integration with employee records | System integration |
| **Compliance Officers** | Audit reports, compliance tracking | 5-10 |
| **IT Operations** | Monitor system health, perform maintenance | 3-5 |

### Enterprise System Context

```
┌─────────────────────────────────────────────────────────────────┐
│                      External Systems                           │
│                                                                 │
│  ┌───────────┐  ┌──────────────┐  ┌────────────┐             │
│  │  Azure AD │  │  HR System   │  │   Email    │             │
│  │  (Entra)  │  │  (Workday/   │  │  Service   │             │
│  │           │  │   SAP, etc.) │  │  (SendGrid)│             │
│  └─────┬─────┘  └──────┬───────┘  └─────┬──────┘             │
│        │               │                │                     │
└────────┼───────────────┼────────────────┼─────────────────────┘
         │               │                │
         │ OAuth 2.0     │ REST API       │ SMTP/API
         │               │                │
┌────────▼───────────────▼────────────────▼─────────────────────┐
│                   Azure Cloud Environment                      │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              Azure Front Door (Global CDN + WAF)         │ │
│  │  • SSL/TLS termination                                   │ │
│  │  • DDoS protection                                       │ │
│  │  • Web Application Firewall                              │ │
│  └────────────────────────┬─────────────────────────────────┘ │
│                           │                                   │
│  ┌────────────────────────▼─────────────────────────────────┐ │
│  │         Azure API Management (Gateway)                    │ │
│  │  • Rate limiting & throttling                            │ │
│  │  • OAuth 2.0 validation                                  │ │
│  │  • Request/response transformation                       │ │
│  │  • API versioning                                        │ │
│  └────────────────────────┬─────────────────────────────────┘ │
│                           │                                   │
│         ┌─────────────────┼──────────────────┐               │
│         │                 │                  │               │
│         ▼                 ▼                  ▼               │
│  ┌──────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Static     │  │  App Service│  │   Azure     │        │
│  │   Web App    │  │  (Web API)  │  │  Functions  │        │
│  │              │  │             │  │             │        │
│  │  React SPA   │  │  ASP.NET    │  │  Background │        │
│  │  + CDN       │  │  Core API   │  │  Jobs       │        │
│  └──────────────┘  └──────┬──────┘  └──────┬──────┘        │
│                           │                │                 │
│         ┌─────────────────┼────────────────┼───────┐        │
│         │                 │                │       │        │
│         ▼                 ▼                ▼       ▼        │
│  ┌───────────┐  ┌──────────────┐  ┌──────────┐  ┌────────┐│
│  │  Azure    │  │   Azure      │  │  Azure   │  │ Azure  ││
│  │  SQL DB   │  │   Cache      │  │   Key    │  │  Blob  ││
│  │           │  │   (Redis)    │  │  Vault   │  │ Storage││
│  │  • Elastic│  │              │  │          │  │        ││
│  │    Pool   │  │  • Session   │  │  • Secrets│  │ • Docs ││
│  │  • Geo-   │  │  • Data      │  │  • Conn  │  │ • Files││
│  │    Repl   │  │    Cache     │  │   Strings│  │        ││
│  └───────────┘  └──────────────┘  └──────────┘  └────────┘│
│                                                              │
│  ┌──────────────────────────────────────────────────────────┐│
│  │           Observability & Security                        ││
│  │                                                           ││
│  │  • Application Insights (telemetry)                      ││
│  │  • Log Analytics (logs aggregation)                      ││
│  │  • Azure Monitor (alerts & dashboards)                   ││
│  │  • Azure Security Center (threat detection)              ││
│  │  • Azure Sentinel (SIEM)                                 ││
│  └──────────────────────────────────────────────────────────┘│
└────────────────────────────────────────────────────────────────┘
```

---

## Non-Functional Requirements

### Performance

| Metric | Target | Measurement |
|--------|--------|-------------|
| **API Response Time (p95)** | <300ms | Application Insights |
| **Page Load Time** | <2s | Real User Monitoring |
| **Time to Interactive** | <3s | Lighthouse scores |
| **Concurrent Users** | 500-1000 | Load testing |
| **Throughput** | 1000 req/sec | Load testing |
| **Database Query Time (p95)** | <50ms | Query Store |

### Scalability

| Dimension | Requirement | Implementation |
|-----------|-------------|----------------|
| **Horizontal Scaling** | Auto-scale to 10 instances | App Service auto-scale rules |
| **Database Scaling** | Up to 100 DTUs (elastic pool) | Azure SQL elastic pool |
| **Storage Scaling** | Unlimited (blob storage) | Azure Blob Storage |
| **Geographic Distribution** | 2+ regions (primary + secondary) | Traffic Manager + geo-replication |
| **Data Volume** | 10K courses, 10K users, 100K enrollments | Database partitioning strategy |

### Availability

| Metric | Target | Implementation |
|--------|--------|----------------|
| **Uptime SLA** | 99.9% (43.8 min downtime/month) | Multi-region deployment |
| **RTO (Recovery Time Objective)** | <4 hours | Automated failover |
| **RPO (Recovery Point Objective)** | <15 minutes | Geo-replication + backups |
| **Maintenance Windows** | Off-hours only (2am-4am) | Blue-green deployment |

### Security

| Requirement | Implementation |
|-------------|----------------|
| **Authentication** | Azure AD (Entra ID) with MFA |
| **Authorization** | RBAC with claims-based policies |
| **Encryption at Rest** | Azure SQL TDE, Blob Storage encryption |
| **Encryption in Transit** | TLS 1.2+ (HTTPS only) |
| **Secrets Management** | Azure Key Vault (no secrets in code) |
| **Network Security** | Virtual Network, Private Endpoints, NSG |
| **DDoS Protection** | Azure DDoS Protection Standard |
| **WAF** | Azure Front Door WAF with OWASP rules |
| **Vulnerability Scanning** | Azure Security Center + Defender |

### Compliance

| Requirement | Implementation |
|-------------|----------------|
| **Data Residency** | Data stored in specified Azure region |
| **GDPR** | Data subject rights, consent management |
| **Audit Logging** | All changes logged to Log Analytics |
| **Data Retention** | 7 years for compliance records |
| **Access Reviews** | Quarterly access reviews (Azure AD) |

---

## Architectural Characteristics

### Cloud-Native Design Principles

#### 1. **12-Factor App Methodology**

| Factor | Implementation |
|--------|----------------|
| **Codebase** | Single repo per service, tracked in Git |
| **Dependencies** | Explicitly declared (NuGet, npm) |
| **Config** | Environment variables, Key Vault |
| **Backing Services** | Attached resources (database, cache) |
| **Build, Release, Run** | Strict separation via CI/CD |
| **Processes** | Stateless (session in Redis, not memory) |
| **Port Binding** | Self-contained services |
| **Concurrency** | Scale via horizontal scaling |
| **Disposability** | Fast startup/shutdown, graceful termination |
| **Dev/Prod Parity** | Dev, Staging, Prod environments match |
| **Logs** | Treat as event streams (Application Insights) |
| **Admin Processes** | Run as one-off processes (Azure Functions) |

#### 2. **Microservices Principles** (Future)

**Current:** Monolithic API  
**Future:** Decomposed services

Potential service boundaries:
- **User Service:** User management, authentication
- **Course Service:** Course catalog, curriculum management
- **Enrollment Service:** Enrollment workflows, tracking
- **Notification Service:** Email, alerts
- **Reporting Service:** Analytics, compliance reports
- **Certificate Service:** Certificate generation

#### 3. **API-First Design**

- OpenAPI specification as source of truth
- Client SDKs generated from spec
- API versioning strategy (v1, v2)
- Backward compatibility guarantees

---

## Multi-Region Deployment Strategy

### Active-Active Configuration (Recommended)

```
┌──────────────────────────────────────────────────────────────┐
│                  Azure Traffic Manager                        │
│  (DNS-based load balancing)                                  │
│                                                              │
│  Routing: Performance-based (lowest latency)                │
│  Health Checks: Endpoint monitoring                          │
└────────────────────┬──────────────────┬──────────────────────┘
                     │                  │
      ┌──────────────┴───────┐   ┌──────┴──────────────┐
      │                      │   │                     │
┌─────▼────────────┐   ┌─────▼────────────┐   ┌──────────────┐
│  Region 1        │   │  Region 2        │   │  Region 3    │
│  (Primary)       │   │  (Secondary)     │   │  (DR Only)   │
│                  │   │                  │   │              │
│  East US         │   │  West Europe     │   │  Australia   │
│                  │   │                  │   │  East        │
│  ┌────────────┐  │   │  ┌────────────┐  │   │  (Cold)      │
│  │ Web API    │  │   │  │ Web API    │  │   │              │
│  └────────────┘  │   │  └────────────┘  │   │              │
│  ┌────────────┐  │   │  ┌────────────┐  │   │              │
│  │ SQL DB     │◄─┼───┼─►│ SQL DB     │  │   │              │
│  │ (Primary)  │  │   │  │ (Read      │  │   │              │
│  │            │  │   │  │  Replica)  │  │   │              │
│  └────────────┘  │   │  └────────────┘  │   │              │
└──────────────────┘   └──────────────────┘   └──────────────┘
```

**Benefits:**
- Users routed to nearest region (low latency)
- Automatic failover if region goes down
- Database geo-replication for data redundancy

**Considerations:**
- Higher cost (multiple deployments)
- Data consistency challenges (eventual consistency)
- Increased complexity

---

## Security Architecture - Defense in Depth

### Layer 1: Network Security

- **Azure Front Door:** DDoS protection, WAF
- **Virtual Network:** Private network for Azure resources
- **Network Security Groups (NSG):** Firewall rules
- **Private Endpoints:** No public internet access to database

### Layer 2: Identity & Access

- **Azure AD Authentication:** MFA enforced
- **Conditional Access Policies:** Risk-based access
- **Privileged Identity Management (PIM):** Just-in-time admin access

### Layer 3: Application Security

- **API Management:** OAuth 2.0 validation, rate limiting
- **Input Validation:** FluentValidation, parameterized queries
- **Output Encoding:** XSS prevention (React auto-escapes)
- **CSRF Protection:** SameSite cookies, anti-forgery tokens

### Layer 4: Data Security

- **Encryption at Rest:** TDE (SQL), Storage Service Encryption (Blob)
- **Encryption in Transit:** TLS 1.2+ only
- **Always Encrypted:** Sensitive columns (SSN, credit card)
- **Dynamic Data Masking:** Hide sensitive data from non-privileged users

### Layer 5: Monitoring & Response

- **Security Center:** Threat detection, recommendations
- **Sentinel:** SIEM for security event correlation
- **Audit Logs:** All changes logged to Log Analytics
- **Incident Response:** Automated playbooks (Logic Apps)

---

## Cost Optimization Strategy

### Right-Sizing Resources

| Resource | POC | Production | Savings |
|----------|-----|------------|---------|
| **App Service** | F1 Free | P1V3 ($146/mo) | None (need scale) |
| **Azure SQL** | LocalDB | S3 Standard ($150/mo) | Use elastic pool |
| **Redis Cache** | None | C1 Basic ($55/mo) | Reduce to C0 if low traffic |
| **Storage** | None | LRS ($0.018/GB) | Use lifecycle policies |

**Total Estimated Monthly Cost:** $500-750 for 100-500 users

### Cost Management Practices

1. **Reserved Instances:** 1-year or 3-year commitment (30-60% savings)
2. **Auto-Scaling:** Scale down during off-hours (nights, weekends)
3. **Resource Tagging:** Tag by department for chargeback
4. **Budget Alerts:** Alert at 80%, 90%, 100% of budget
5. **Lifecycle Policies:** Move old data to cool/archive storage

---

## Observability Stack

### Application Insights - Telemetry

```
Frontend (React)
    │ JavaScript SDK
    ├─► Page Views
    ├─► User Sessions
    ├─► Custom Events
    └─► Exceptions
    
Backend (ASP.NET Core)
    │ .NET SDK
    ├─► Requests (HTTP)
    ├─► Dependencies (DB, Redis, External APIs)
    ├─► Exceptions
    ├─► Custom Metrics
    └─► Distributed Tracing
    
Azure Functions
    │ Built-in Integration
    └─► Function Executions
```

### Log Analytics - Logs

- Structured logging (JSON)
- Correlation IDs for request tracing
- KQL queries for analysis
- Retention: 90 days (default), 2 years (compliance)

### Azure Monitor - Dashboards & Alerts

**Key Dashboards:**
- Executive: Uptime, error rate, active users
- Operations: CPU, memory, response times
- Security: Failed logins, unusual activity

**Alert Rules:**
- Response time > 1s (p95) → Page on-call engineer
- Error rate > 5% → Create incident ticket
- Database DTU > 80% → Auto-scale trigger

---

## Migration Approach

### Phase 1: Lift & Shift (Months 1-2)

**Goal:** Move POC to Azure with minimal changes

- Deploy to Azure App Service (Web API)
- Deploy to Azure SQL Database
- Deploy frontend to Azure Static Web Apps
- Set up CI/CD pipelines

**Risk:** Low (infrastructure change only, no code changes)

### Phase 2: Modernization (Months 2-4)

**Goal:** Add enterprise features

- Integrate Azure AD authentication
- Implement RBAC authorization
- Add caching layer (Redis)
- Configure auto-scaling
- Set up monitoring (Application Insights)

**Risk:** Medium (code changes, testing required)

### Phase 3: Optimization (Months 4-6)

**Goal:** Optimize for production workload

- Multi-region deployment
- Performance tuning (database indexing)
- Load testing and optimization
- Security hardening (WAF, DDoS)
- Disaster recovery setup

**Risk:** Medium (complex deployment, thorough testing needed)

### Phase 4: Production Launch (Month 6)

**Goal:** Go-live with production users

- User acceptance testing (UAT)
- Staged rollout (10% → 50% → 100%)
- Monitoring and incident response ready
- Training and documentation complete

**Risk:** High (production cutover, rollback plan essential)

---

## Compliance & Governance

### Data Residency

- Data stored in specified Azure region (e.g., East US)
- Geo-replication within same geography (US → US)
- No data transfer outside geography without consent

### GDPR Compliance

- **Right to Access:** Users can export their data
- **Right to Erasure:** Delete user data on request
- **Right to Rectification:** Users can update their info
- **Data Minimization:** Collect only necessary data
- **Consent Management:** Track consent for data processing

### Audit Logging

| Event | Logged Information |
|-------|-------------------|
| **User Login** | User ID, timestamp, IP address, MFA status |
| **Data Access** | User ID, resource accessed, timestamp |
| **Data Modification** | User ID, before/after values, timestamp |
| **Admin Actions** | Admin ID, action performed, affected users |
| **Security Events** | Failed login attempts, privilege escalation |

**Retention:** 7 years for compliance, searchable via Log Analytics

---

## References

- [Cloud-Native Frontend Architecture](./02-frontend-architecture.md)
- [Microservices Backend Architecture](./03-backend-architecture.md)
- [Enterprise Data Architecture](./04-data-architecture.md)
- [Migration Strategy](./13-migration-strategy.md)
- [Cost Optimization Guide](./12-cost-optimization.md)

---

**Next:** [Cloud-Native Frontend Architecture →](./02-frontend-architecture.md)
