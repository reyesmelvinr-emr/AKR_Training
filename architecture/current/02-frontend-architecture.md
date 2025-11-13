# Frontend Architecture - Current POC

[← Back to Architecture Overview](../../ARCHITECTURE_CURRENT_POC.md)

---

## Overview

The Training Tracker frontend is a **Single Page Application (SPA)** built with React 18, TypeScript, and Vite. It follows a component-based architecture with clear separation between presentation, business logic, and data fetching.

---

## Technology Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| React | 18.3 | UI framework |
| TypeScript | 5.5 | Type safety |
| Vite | 5.4 | Build tool & dev server |
| React Router DOM | 6.x | Client-side routing |
| Axios | 1.x | HTTP client |
| CSS Modules | N/A | Component styling |

---

## Project Structure

```
training-tracker-ui/
├── public/                      # Static assets
├── src/
│   ├── main.tsx                # Application entry point
│   ├── App.tsx                 # Root component
│   ├── vite-env.d.ts          # Vite type definitions
│   ├── global.d.ts            # Global type definitions
│   │
│   ├── components/             # Reusable UI components
│   │   ├── common/            # Generic components
│   │   │   ├── Button.tsx
│   │   │   ├── Button.module.css
│   │   │   ├── Card.tsx
│   │   │   ├── Card.module.css
│   │   │   ├── Table.tsx
│   │   │   ├── Table.module.css
│   │   │   ├── StatusBadge.tsx
│   │   │   ├── StatusBadge.module.css
│   │   │   ├── Layout.tsx
│   │   │   └── Layout.module.css
│   │   │
│   │   ├── courses/           # Course-specific components
│   │   │   ├── CourseModal.tsx
│   │   │   └── CourseModal.module.css
│   │   │
│   │   ├── users/             # User-specific components
│   │   │   ├── UserModal.tsx
│   │   │   └── UserModal.module.css
│   │   │
│   │   └── admin/             # Admin-specific components
│   │       ├── AdminPanel.tsx
│   │       └── AdminPanel.module.css
│   │
│   ├── pages/                 # Page-level components
│   │   ├── Dashboard.tsx      # Personal training dashboard
│   │   ├── CourseCatalog.tsx  # Course management
│   │   ├── Users.tsx          # User management
│   │   ├── Enrollments.tsx    # Enrollment management
│   │   └── AdminPanel.tsx     # Admin dashboard
│   │
│   ├── services/              # API client services
│   │   ├── api.ts            # Axios instance configuration
│   │   ├── coursesService.ts
│   │   ├── usersService.ts
│   │   ├── enrollmentsService.ts
│   │   └── adminService.ts
│   │
│   ├── hooks/                 # Custom React hooks
│   │   ├── useCourses.ts
│   │   ├── useUsers.ts
│   │   ├── useEnrollments.ts
│   │   ├── useStatistics.ts
│   │   └── useHealth.ts
│   │
│   ├── context/               # React Context providers
│   │   └── AuthContext.tsx   # Authentication context (placeholder)
│   │
│   ├── utils/                 # Utility functions
│   │   └── formatters.ts     # Date, currency formatters
│   │
│   └── mocks/                 # Mock data (unused in EF mode)
│       └── mockData.ts
│
├── index.html                 # Entry HTML
├── vite.config.ts            # Vite configuration
├── tsconfig.json             # TypeScript configuration
├── package.json              # Dependencies
└── .env                      # Environment variables
```

---

## Architecture Patterns

### 1. **Component Hierarchy**

```
App.tsx
├── React Router (BrowserRouter)
│   ├── Layout (Sidebar + Header)
│   │   ├── Dashboard Page
│   │   │   └── Card, StatusBadge, Table components
│   │   │
│   │   ├── CourseCatalog Page
│   │   │   ├── Button, Table components
│   │   │   └── CourseModal (Create/Edit)
│   │   │
│   │   ├── Users Page
│   │   │   ├── Button, Table components
│   │   │   └── UserModal (Create/Edit)
│   │   │
│   │   ├── Enrollments Page
│   │   │   ├── Card, StatusBadge, Table components
│   │   │   └── EnrollmentModal (Create)
│   │   │
│   │   └── Admin Panel Page
│   │       ├── Card (Statistics)
│   │       ├── StatusBadge (Health)
│   │       └── Table (Bulk Operations)
│   │
│   └── AuthContext.Provider
```

### 2. **Data Flow Pattern**

```
┌─────────────────────────────────────────────────────────┐
│                      User Action                         │
│  (Button click, form submit, page load)                 │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               React Component                            │
│  • Calls custom hook (useCourses, useUsers, etc.)       │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               Custom Hook                                │
│  • Manages state (loading, error, data)                 │
│  • Calls service function                               │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               Service Layer                              │
│  • coursesService.getAll()                              │
│  • Wraps Axios HTTP call                                │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               Axios HTTP Client                          │
│  • Adds correlation ID header                           │
│  • Sends GET /api/courses                               │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               Backend API                                │
│  • Processes request, returns JSON                       │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               Service Layer Response                     │
│  • Returns data or throws error                          │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               Custom Hook                                │
│  • Updates state: loading=false, data=response           │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               React Component Re-renders                 │
│  • Displays data in Table, Card, etc.                   │
└─────────────────────────────────────────────────────────┘
```

### 3. **CSS Modules Architecture**

**Pattern:** Each component has a dedicated `.module.css` file

**Example:**
```tsx
// Button.tsx
import styles from './Button.module.css';

export const Button = ({ variant, children, onClick }: ButtonProps) => {
  return (
    <button 
      className={styles[variant]} 
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```

```css
/* Button.module.css */
.primary {
  background-color: #2563eb;
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;
}

.secondary {
  background-color: #6b7280;
  color: white;
}

.danger {
  background-color: #dc2626;
  color: white;
}
```

**Benefits:**
- ✅ Scoped styles (no global namespace pollution)
- ✅ TypeScript autocomplete for class names
- ✅ Easy to refactor (rename class, IDE finds all usages)
- ✅ No build configuration needed (Vite supports out-of-box)
- ✅ Co-located with component (easier maintenance)

**Existing CSS Module Files:**
- `Layout.module.css` (260 lines) - Navigation sidebar, page layout
- `Card.module.css` - Reusable card component
- `Button.module.css` - Button variants
- `Table.module.css` - Data table styling
- `StatusBadge.module.css` - Status indicators
- `AdminPanel.module.css` (256 lines) - Admin dashboard with responsive grid

---

## Routing Strategy

### React Router Configuration

**File:** `src/main.tsx`

```tsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';

<BrowserRouter>
  <Routes>
    <Route path="/" element={<Layout />}>
      <Route index element={<Dashboard />} />
      <Route path="courses" element={<CourseCatalog />} />
      <Route path="users" element={<Users />} />
      <Route path="enrollments" element={<Enrollments />} />
      <Route path="admin" element={<AdminPanel />} />
    </Route>
  </Routes>
</BrowserRouter>
```

### Route Definitions

| Path | Component | Purpose | Auth Required |
|------|-----------|---------|---------------|
| `/` | Dashboard | Personal training dashboard (user's enrollments) | Yes (future) |
| `/courses` | CourseCatalog | Browse and manage course catalog | Yes (future) |
| `/users` | Users | User management (admin only) | Yes + Admin |
| `/enrollments` | Enrollments | Enrollment management | Yes (future) |
| `/admin` | AdminPanel | System administration dashboard | Yes + Admin |

**Current State:** All routes accessible (no auth enforcement yet)

**Future:** Protected routes with role-based access control

---

## State Management

### Approach: React Context API + Custom Hooks

**No Redux:** Application state is simple enough for Context API

### Authentication State

**File:** `src/context/AuthContext.tsx`

```tsx
interface AuthContextType {
  isAuthenticated: boolean;
  currentUser: string;
  userRole: string;
}

// Current: Placeholder implementation
const authContext: AuthContextType = {
  isAuthenticated: true,
  currentUser: 'alice@example.com',
  userRole: 'admin'
};
```

**Future:** Integrate with Azure AD, store JWT tokens

### Data Fetching State

**Pattern:** Custom hooks manage loading, error, and data states

**Example: useCourses Hook**

```tsx
export const useCourses = () => {
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchCourses = async () => {
    try {
      setLoading(true);
      const data = await coursesService.getAll();
      setCourses(data.items);
      setError(null);
    } catch (err) {
      setError('Failed to load courses');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCourses();
  }, []);

  return { courses, loading, error, refetch: fetchCourses };
};
```

**Usage in Component:**

```tsx
const CourseCatalog = () => {
  const { courses, loading, error, refetch } = useCourses();

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <Table data={courses} />
  );
};
```

---

## API Integration

### Axios Configuration

**File:** `src/services/api.ts`

```tsx
import axios from 'axios';

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:5115',
  headers: {
    'Content-Type': 'application/json'
  }
});

// Request interceptor: Add correlation ID
apiClient.interceptors.request.use((config) => {
  config.headers['X-Correlation-Id'] = crypto.randomUUID();
  return config;
});

// Response interceptor: Handle errors
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      // Server responded with error status
      console.error('API Error:', error.response.data);
    } else if (error.request) {
      // Request made but no response
      console.error('Network Error:', error.message);
    }
    return Promise.reject(error);
  }
);

export default apiClient;
```

### Service Layer Pattern

**File:** `src/services/coursesService.ts`

```tsx
import apiClient from './api';
import { Course, CourseListResponse } from '../types';

export const coursesService = {
  getAll: async (page = 1, pageSize = 10): Promise<CourseListResponse> => {
    const response = await apiClient.get(`/api/courses`, {
      params: { page, pageSize }
    });
    return response.data;
  },

  getById: async (id: string): Promise<Course> => {
    const response = await apiClient.get(`/api/courses/${id}`);
    return response.data;
  },

  create: async (course: CreateCourseRequest): Promise<Course> => {
    const response = await apiClient.post('/api/courses', course);
    return response.data;
  },

  update: async (id: string, course: UpdateCourseRequest): Promise<Course> => {
    const response = await apiClient.put(`/api/courses/${id}`, course);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/api/courses/${id}`);
  }
};
```

**Benefits:**
- Centralized API calls
- Easy to mock for testing
- Type-safe with TypeScript interfaces
- Error handling in one place

---

## Component Design

### Reusable Components

#### 1. **Button Component**

**File:** `src/components/common/Button.tsx`

**Variants:** `primary`, `secondary`, `danger`

**Props:**
```tsx
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'danger';
  children: React.ReactNode;
  onClick?: () => void;
  type?: 'button' | 'submit';
  disabled?: boolean;
}
```

**Usage:**
```tsx
<Button variant="primary" onClick={handleSave}>
  Save
</Button>
```

#### 2. **Card Component**

**File:** `src/components/common/Card.tsx`

**Purpose:** Container for content sections

**Props:**
```tsx
interface CardProps {
  title?: string;
  children: React.ReactNode;
  className?: string;
}
```

**Usage:**
```tsx
<Card title="Course Statistics">
  <p>Total Courses: 25</p>
</Card>
```

#### 3. **Table Component**

**File:** `src/components/common/Table.tsx`

**Purpose:** Display tabular data with pagination

**Props:**
```tsx
interface TableProps<T> {
  columns: Column<T>[];
  data: T[];
  onEdit?: (item: T) => void;
  onDelete?: (item: T) => void;
  pagination?: PaginationInfo;
  onPageChange?: (page: number) => void;
}
```

**Usage:**
```tsx
<Table
  columns={courseColumns}
  data={courses}
  onEdit={handleEdit}
  onDelete={handleDelete}
  pagination={paginationInfo}
/>
```

#### 4. **StatusBadge Component**

**File:** `src/components/common/StatusBadge.tsx`

**Purpose:** Display status indicators

**Variants:** `success`, `warning`, `danger`, `info`

**Props:**
```tsx
interface StatusBadgeProps {
  status: 'success' | 'warning' | 'danger' | 'info';
  label: string;
}
```

**Usage:**
```tsx
<StatusBadge status="success" label="Active" />
<StatusBadge status="warning" label="Pending" />
<StatusBadge status="danger" label="Expired" />
```

---

## Pages

### 1. Dashboard Page

**Purpose:** Personal training dashboard showing user's enrollments

**Features:**
- Statistics cards (Total, Completed, In Progress, Overdue)
- User's enrollment table
- Status indicators
- Action buttons (Complete, Cancel)

**Data Source:** `/api/enrollments` filtered by current user

### 2. Course Catalog Page

**Purpose:** Browse and manage training courses

**Features:**
- Course table (Title, Category, Validity, Required, Active, Actions)
- Add Course button → Modal form
- Edit button → Pre-populated modal
- Delete button → Confirmation prompt
- Pagination controls

**CRUD Operations:**
- ✅ Create: POST /api/courses
- ✅ Read: GET /api/courses
- ✅ Update: PUT /api/courses/{id}
- ✅ Delete: DELETE /api/courses/{id}

### 3. Users Page

**Purpose:** User management (admin only)

**Features:**
- User table (Name, Email, Active, Actions)
- Add User button → Modal form
- Edit/Delete actions
- Pagination

**CRUD Operations:**
- ✅ Create: POST /api/users
- ✅ Read: GET /api/users
- ✅ Update: PUT /api/users/{id}
- ✅ Delete: DELETE /api/users/{id}

### 4. Enrollments Page

**Purpose:** Enrollment management

**Features:**
- Statistics cards
- Enrollment table with user/course names
- Enroll button → Modal with dropdowns
- Complete/Cancel/Delete actions
- Status badges

**CRUD Operations:**
- ✅ Create: POST /api/enrollments
- ✅ Read: GET /api/enrollments
- ✅ Update: PATCH /api/enrollments/{id}/complete
- ✅ Delete: DELETE /api/enrollments/{id}

### 5. Admin Panel Page

**Purpose:** System administration dashboard

**Features:**
- **Section 1:** System Health Dashboard (4 cards with metrics)
- **Section 2:** Statistics Dashboard (4 cards with data)
- **Section 3:** Bulk User Operations (table with checkboxes, bulk actions)
- Responsive 4-column grid (CSS Modules)
- Auto-refresh health status (30s interval)

**API Endpoints:**
- GET /api/admin/statistics
- GET /api/admin/health
- PATCH /api/admin/users/bulk-status

---

## Performance Optimization

### Current Optimizations

1. **Code Splitting:** React.lazy() for route-based code splitting (future)
2. **Memoization:** Minimal use of useMemo/useCallback (not needed yet)
3. **Vite Build:** Optimized production builds with tree-shaking
4. **CSS Modules:** Scoped styles reduce CSS bundle size

### Future Optimizations

- [ ] Implement virtual scrolling for large tables
- [ ] Add debouncing for search inputs
- [ ] Lazy load modals (React.lazy)
- [ ] Implement service worker for offline support (PWA)
- [ ] Add image optimization (if images added)
- [ ] Bundle analysis and optimization

---

## Accessibility

### Current Implementation

- ✅ Semantic HTML (`<button>`, `<table>`, `<nav>`)
- ✅ Keyboard navigation (native browser support)
- ⚠️ ARIA labels (minimal, needs improvement)
- ❌ Screen reader testing (not done)

### Future Improvements

- [ ] Add ARIA labels to all interactive elements
- [ ] Implement focus management for modals
- [ ] Add skip navigation links
- [ ] Test with screen readers (NVDA, JAWS)
- [ ] Ensure color contrast meets WCAG AA standards
- [ ] Add focus indicators (keyboard navigation)

---

## Testing Strategy

### Current State

- ❌ No unit tests
- ❌ No integration tests
- ❌ No end-to-end tests
- ✅ Manual testing only

### Recommended Approach

**1. Unit Tests (Vitest + React Testing Library)**
```tsx
describe('Button', () => {
  it('calls onClick when clicked', () => {
    const handleClick = vi.fn();
    render(<Button variant="primary" onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByText('Click me'));
    
    expect(handleClick).toHaveBeenCalledOnce();
  });
});
```

**2. Integration Tests**
- Test page components with mocked API calls
- Verify data flow from service → hook → component

**3. E2E Tests (Playwright/Cypress)**
- Test complete user journeys
- Verify CRUD operations end-to-end

---

## Build and Deployment

### Development

```bash
npm run dev
```

- Starts Vite dev server on http://localhost:5174
- Hot Module Replacement (HMR) enabled
- TypeScript type checking in IDE

### Production Build

```bash
npm run build
```

- Compiles TypeScript to JavaScript
- Bundles with Rollup
- Minifies code
- Outputs to `dist/` folder

### Preview Production Build

```bash
npm run preview
```

- Serves production build locally
- Test before deployment

---

## Environment Configuration

### .env File

```env
VITE_API_BASE_URL=http://localhost:5115
VITE_USE_API_MOCKS=false
```

**Usage in Code:**
```tsx
const apiBaseUrl = import.meta.env.VITE_API_BASE_URL;
```

**Important:** Vite only exposes variables prefixed with `VITE_`

---

## Known Limitations

1. **No Authentication:** Placeholder user (alice@example.com)
2. **No Authorization:** All users can access all pages
3. **No Error Boundaries:** Unhandled errors crash entire app
4. **No Loading Indicators:** Basic "Loading..." text only
5. **No Success Notifications:** Silent success (no toasts)
6. **No Offline Support:** Requires internet connection
7. **No Dark Mode:** Light theme only
8. **No Internationalization:** English only

---

## References

- [Backend Architecture](./03-backend-architecture.md)
- [UI Components Reference](../../UI_COMPONENTS_REFERENCE.md)
- [React Documentation](https://react.dev/)
- [Vite Documentation](https://vitejs.dev/)
- [CSS Modules Documentation](https://github.com/css-modules/css-modules)

---

**Next:** [Backend Architecture →](./03-backend-architecture.md)
