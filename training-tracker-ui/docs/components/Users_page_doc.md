# Component Documentation: Users Page

## Metadata

**Component Type**: Page Component  
**Repository**: training-tracker-ui  
**File Path**: `src/pages/Users.tsx`  
**Last Updated**: 2025-11-12  
**Tags**: #user-management #user-profile #ui-component #page #table #form #modal #core-feature

---

**File**: `src/pages/Users.tsx`  
**Type**: Page (Container Component)  
**Complexity**: Complex  
**Last Updated**: 2025-11-12

---

## Quick Reference

| | |
|---|---|
| **What it does** | 🤖 Full-featured user management page with CRUD operations, displaying paginated user list in a table with inline edit/delete actions and modal-based create/edit forms |
| **When to use** | ❓ Admin dashboard for managing system user accounts. Primary interface for user administration tasks including creating, viewing, editing, and deleting users. |
| **When NOT to use** | ❓ User profile page (use dedicated UserProfile component). Simple user list without admin actions (use UserList component). Public user directory (lacks authorization). |
| **Accessibility** | 🤖 ARIA labels on action buttons, semantic HTML table, keyboard-navigable forms, focus management in modals. ❓ WCAG level testing pending. Screen reader testing needed. |
| **Status** | 🤖 Stable - Core admin functionality |

**Example usage**:
```tsx
🤖 // Rendered by router
import { Users } from '@/pages/Users';

// In router configuration
<Route path="/users" element={<Users />} />
```

---

## Purpose & Context

### What This Component Does

🤖 The `Users` page component provides a complete user management interface for administrators. It displays a paginated table of all system users with their email, full name, active status, and creation date. Each row includes Edit and Delete action buttons. Users can be created or edited through a modal form that validates input and handles API errors. The component manages loading states, error handling, form validation, and data refetching after mutations.

**Key responsibilities**:
- Display paginated list of users in a table format
- Provide Add User button to create new accounts
- Enable inline Edit/Delete actions per user row
- Show modal dialog for create/edit user forms
- Handle form validation and submission
- Manage API communication for CRUD operations
- Display loading, error, and success states
- Implement pagination controls

❓ **Business context**:
- Central admin interface for user account management
- Used by system administrators to onboard new users
- Enables deactivation of user accounts (soft delete via IsActive flag)
- Supports bulk user management through table view
- Critical for maintaining accurate employee/user records in training system

---

### When to Use This Component

🤖 **Use this component when:**
- Building admin dashboard routing (path: `/users`)
- Administrators need to manage user accounts
- Full CRUD operations on users are required
- Paginated list view with inline actions needed
- Modal-based forms preferred over separate pages

❓ **Real application examples:**
- Admin panel: User management section
- HR system integration: Manual user account creation
- Support dashboard: Troubleshooting user account issues
- User onboarding: Create accounts for new employees
- User offboarding: Deactivate accounts for departed employees

---

### When NOT to Use This Component

🤖 **Don't use this component when:**
- User profile editing (self-service) → Use `UserProfile` component instead
- Read-only user directory → Use `UserList` component without actions
- Public user listing → Use public-facing component with authorization
- Embedded user selector → Use `UserPicker` or `UserAutocomplete`
- Simple user count display → Use `UserStats` widget

❓ **Alternative components:**
- `UserProfile` - For users editing their own profile
- `UserList` - For read-only user display without admin actions
- `UserPicker` - For selecting users in forms (autocomplete)
- `UserCard` - For displaying single user details

---

## Props API

🤖 **This component accepts NO props** - it's a page component rendered by the router.

### Internal State

🤖 The component manages the following internal state:

| State Variable | Type | Purpose |
|---------------|------|---------|
| `page` | `number` | Current pagination page (default: 1) |
| `showModal` | `boolean` | Controls modal dialog visibility |
| `editingUserId` | `string \| null` | ID of user being edited, null for create mode |
| `formData` | `UserFormData` | Form field values (email, fullName, isActive) |
| `formError` | `string \| null` | Form-level error message from API |
| `formLoading` | `boolean` | Form submission loading state |

### Custom Hooks Used

🤖 **`useUsers(page, pageSize, enabled)`**

Fetches paginated user data from API.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | `number` | 1 | Current page number |
| `pageSize` | `number` | 10 | Items per page (constant) |
| `enabled` | `boolean` | true | Enable/disable fetch |

**Returns**:
```typescript
{
  data: PagedUsers | null,     // Paginated user data
  loading: boolean,             // Fetch loading state
  error: string | null,         // Fetch error message
  refetch: () => void          // Manual refetch function
}
```

---

## Visual States & Variants

❓ **Page-level states:**

### Visual States

| State | Description | Visual Appearance | Interaction |
|-------|-------------|-------------------|-------------|
| **Loading** | Initial data fetch | "Loading users..." text shown | No table displayed yet |
| **Error** | API fetch failed | Red error message in Card | Retry by refreshing page |
| **Empty** | No users in system | ❓ Empty table (implementation unclear) | Can add users via Add User button |
| **Populated** | Users loaded successfully | Table with user rows, pagination controls | Full CRUD interactions available |
| **Modal Open** | Create/Edit form visible | Overlay with modal dialog, blurred background | Form input, submit, or cancel |
| **Form Submitting** | Saving user data | ❓ Submit button shows loading state | Form fields disabled |
| **Form Error** | Validation/API error | Red error banner in modal | User can correct and resubmit |

### Table Row States

| State | Description | Visual Appearance |
|-------|-------------|-------------------|
| **Active User** | IsActive = true | Green "Active" badge |
| **Inactive User** | IsActive = false | Red "Inactive" badge |
| **Hover** | Mouse over row | ❓ Row highlight (depends on Table component) |

---

## Component Behavior

### User Interactions

❓ **Interaction patterns:**

| User Action | Component Response | Side Effects |
|-------------|-------------------|--------------|
| **Page Load** | Fetches users for page 1 via useUsers hook | API call to GET /api/users |
| **Click "Add User"** | Opens modal with empty form, editingUserId=null | Sets showModal=true, clears formData |
| **Click "Edit" button** | Opens modal with user data pre-filled, editingUserId set | Finds user in data, populates formData |
| **Click "Delete" button** | Shows browser confirm dialog, deletes if confirmed | API call to DELETE /api/users/{id}, refetches data |
| **Submit Create Form** | Validates, posts to API, closes modal on success | API call to POST /api/users, refetch, close modal |
| **Submit Edit Form** | Validates, updates via API, closes modal on success | API call to PUT /api/users/{id}, refetch, close modal |
| **Click modal overlay/close** | Closes modal, resets form state | Sets showModal=false, clears editingUserId/formData |
| **Click "Previous" page** | Decrements page state, triggers refetch | Updates page state, useUsers refetches |
| **Click "Next" page** | Increments page state, triggers refetch | Updates page state, useUsers refetches |

### State Management

🤖 **State mode**: Uncontrolled (internal state only)

**State flow**:
```
1. Component mounts
   ↓
2. useUsers hook fetches page 1 data
   ↓
3. User clicks "Add User"
   ↓
4. showModal=true, formData reset, editingUserId=null
   ↓
5. User fills form and submits
   ↓
6. formLoading=true, API POST /api/users
   ↓
7. Success: refetch data, close modal
   OR
   Error: formError set, modal stays open
```

**Form state management**:
- **Uncontrolled form inputs**: Each input uses controlled React state via formData
- **Validation**: Browser HTML5 validation (required, email type) + API-level validation
- **Error handling**: API errors displayed in red banner above form
- **Reset on close**: Form data cleared when modal closes

---

### Side Effects

❓ **Observable side effects:**

**This component triggers**:
- ✅ API calls to `/api/users` endpoints:
  - `GET /api/users?page={page}&pageSize=10` - Fetch paginated users
  - `POST /api/users` - Create new user
  - `PUT /api/users/{id}` - Update existing user
  - `DELETE /api/users/{id}` - Delete user
- ✅ Browser confirm dialog on delete action
- ✅ Data refetch after successful create/update/delete
- ❓ No analytics events tracked (should we add?)
- ❓ No audit logging visible (handled server-side?)
- ❓ No success notifications/toasts (just closes modal)
- ❓ No optimistic UI updates (waits for API response)

---

## Styling & Theming

### CSS Modules

🤖 **This component uses inline styles** (no separate CSS module)

**Inline styles used**:
- Page layout: `display: flex, flexDirection: column, gap: 1.5rem`
- Header row: `display: flex, justifyContent: space-between, alignItems: center`
- Action buttons in table: `display: flex, gap: 8`
- Pagination controls: `display: flex, justifyContent: center, alignItems: center, gap: 1rem`
- Modal overlay: `position: fixed, top/left/right/bottom: 0, backgroundColor: rgba(0,0,0,0.5), zIndex: 1000`
- Modal content: `backgroundColor: white, borderRadius: 8px, padding: 24px, maxWidth: 500px`
- Form inputs: `width: 100%, padding: 8px 12px, border: 1px solid #d1d5db, borderRadius: 4px`
- Error banner: `backgroundColor: #fee2e2, color: #991b1b, borderRadius: 4px`

❓ **Styling approach concerns**:
- Heavy use of inline styles reduces maintainability
- No CSS module for component-specific styles
- Hard-coded color values (should use design tokens)
- No responsive design (fixed widths, no mobile breakpoints)

---

### Design Tokens

❓ **Design token usage:**

**Hard-coded values found** (should be design tokens):
- Colors: `#fee2e2`, `#991b1b`, `#fecaca`, `#d1d5db`, `white`, `rgba(0,0,0,0.5)`
- Spacing: `1.5rem`, `1rem`, `24px`, `16px`, `12px`, `8px`
- Border radius: `8px`, `4px`
- Font size: `14px`
- Z-index: `1000`

**Recommended refactor**:
```css
/* Use design tokens instead */
--color-error-bg: #fee2e2;
--color-error-text: #991b1b;
--color-border: #d1d5db;
--space-sm: 8px;
--space-md: 12px;
--space-lg: 16px;
--space-xl: 24px;
--radius-sm: 4px;
--radius-md: 8px;
--z-modal: 1000;
```

---

### Customization

❓ **Current customization limitations:**
- ❌ No props for customization (page component)
- ❌ Inline styles prevent easy theming
- ❌ Hard-coded pagination page size (10)
- ❌ Hard-coded modal dimensions
- ❌ No layout variants (table-only vs. grid vs. cards)

**Potential improvements**:
- Extract to CSS module for easier customization
- Add config props for page size, table columns
- Support layout mode prop (table | grid | list)
- Add theme provider integration

---

## Accessibility

### ARIA Attributes

🤖 **ARIA attributes detected:**

| Element | ARIA Attribute | Value | Purpose |
|---------|---------------|-------|---------|
| Edit button | `aria-label` | `Edit {fullName}` | Screen reader context for who's being edited |
| Delete button | `aria-label` | `Delete {fullName}` | Screen reader context for who's being deleted |
| Table | (via Table component) | ❓ | Assumed: caption, proper table semantics |

❓ **Missing ARIA attributes:**
- Modal dialog lacks `role="dialog"`, `aria-modal="true"`, `aria-labelledby`
- Modal close button has no aria-label
- Form inputs lack `aria-invalid` for error states
- Error banner lacks `role="alert"`
- Pagination controls lack `aria-label` or `aria-current`

---

### Keyboard Support

❓ **Keyboard navigation:**

| Key | Action | Implementation Status |
|-----|--------|----------------------|
| Tab | Navigate between buttons, inputs, table cells | ✅ Native browser behavior |
| Enter | Submit form, activate buttons | ✅ Native browser behavior |
| Escape | Close modal | ❌ Not implemented |
| Arrow keys | Navigate table | ❓ Depends on Table component |
| Space | Activate buttons | ✅ Native browser behavior |

**Missing keyboard support**:
- ❌ Escape key to close modal
- ❌ Focus trap in modal (focus can escape to background)
- ❌ Focus restoration after modal closes
- ❌ Keyboard shortcuts for common actions (e.g., Ctrl+N for new user)

---

### Screen Reader Support

❓ **Screen reader testing needed:**
- Status badges ("Active"/"Inactive") - are they announced correctly?
- Table navigation - can screen readers understand table structure?
- Modal announcements - is modal opening announced?
- Form errors - are validation errors announced?
- Loading states - is "Loading users..." announced?
- Success feedback - is successful creation/update announced?

**Recommendations**:
- Add `role="alert"` to error messages
- Add `aria-live="polite"` to loading states
- Add `aria-describedby` to form inputs linking to error messages
- Test with NVDA, JAWS, VoiceOver

---

### WCAG Compliance

❓ **WCAG compliance status:**

| Criterion | Level | Status | Notes |
|-----------|-------|--------|-------|
| 1.3.1 Info and Relationships | A | ❓ | Table semantics depend on Table component |
| 1.4.3 Contrast (Minimum) | AA | ❓ | Needs contrast testing on error colors |
| 2.1.1 Keyboard | A | ⚠️ | Partial - modal lacks escape key |
| 2.4.3 Focus Order | A | ❓ | Needs testing - modal focus trap |
| 2.4.7 Focus Visible | AA | ✅ | Browser default focus indicators |
| 3.2.2 On Input | A | ✅ | No unexpected context changes |
| 3.3.1 Error Identification | A | ⚠️ | Partial - errors shown but not ARIA-announced |
| 3.3.2 Labels or Instructions | A | ✅ | All inputs have labels |
| 4.1.2 Name, Role, Value | A | ⚠️ | Partial - modal lacks proper ARIA |

---

## Usage Examples

### Example 1: Basic Rendering (Router Integration)

```tsx
🤖 // In App.tsx or router configuration
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Users } from '@/pages/Users';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/users" element={<Users />} />
      </Routes>
    </BrowserRouter>
  );
}
```

**Use case**: ❓ Admin navigates to /users route to manage user accounts.

---

### Example 2: User Creation Flow

```tsx
🤖 // User interaction flow (not code)
// 1. Admin clicks "Add User" button
// 2. Modal opens with empty form
// 3. Admin enters:
//    - Email: "newuser@example.com"
//    - Full Name: "John Doe"
//    - Is Active: true (default)
// 4. Admin clicks "Save"
// 5. API POST /api/users with data
// 6. On success: modal closes, table refetches, new user appears
// 7. On error: red banner shows error message, modal stays open
```

**Use case**: ❓ Onboarding new employee into training system.

---

### Example 3: User Editing Flow

```tsx
🤖 // User interaction flow (not code)
// 1. Admin clicks "Edit" button on Alice's row
// 2. Modal opens with Alice's data pre-filled:
//    - Email: "alice@example.com"
//    - Full Name: "Alice Example"
//    - Is Active: true
// 3. Admin changes:
//    - Email → "alice.smith@example.com"
//    - Is Active → false (deactivate)
// 4. Admin clicks "Save"
// 5. API PUT /api/users/{alice-id} with updated data
// 6. On success: modal closes, table refetches, Alice's row shows changes
// 7. On error: red banner shows error (e.g., "Email already exists")
```

**Use case**: ❓ Deactivating user account when employee leaves company.

---

### Example 4: User Deletion Flow

```tsx
🤖 // User interaction flow (not code)
// 1. Admin clicks "Delete" button on Bob's row
// 2. Browser confirm dialog appears:
//    "Are you sure you want to delete user 'Bob Example'?"
// 3. Admin clicks "OK"
// 4. API DELETE /api/users/{bob-id}
// 5. On success: table refetches, Bob's row disappears
// 6. On error: alert dialog shows error message
```

**Use case**: ❓ Removing duplicate or test user accounts.

---

### Example 5: Pagination Navigation

```tsx
🤖 // User interaction flow (not code)
// 1. Table shows users 1-10 of 45 total (Page 1 of 5)
// 2. Admin clicks "Next" button
// 3. page state updates to 2
// 4. useUsers hook refetches: GET /api/users?page=2&pageSize=10
// 5. Table updates to show users 11-20
// 6. Pagination controls update: "Page 2 of 5 (45 total users)"
// 7. "Previous" button becomes enabled
```

**Use case**: ❓ Browsing through large user list to find specific account.

---

## Component Architecture

### Dependencies

🤖 **External dependencies:**

| Dependency | Purpose | Type |
|------------|---------|------|
| `React` (useState, useMemo) | State management, memoization | Core framework |
| `useUsers` hook | Fetch paginated user data | Custom hook |
| `usersApi.create/update/delete` | User CRUD operations | API client |
| `Layout` component | Page wrapper with navigation | UI component |
| `Card` component | Content container | UI component |
| `Table` component | Data table display | UI component |
| `Button` component | Action buttons | UI component |
| `StatusBadge` component | Active/Inactive badge | UI component |

### Data Flow

```
┌─────────────┐
│   Router    │ → Renders <Users /> on /users route
└─────────────┘
       ↓
┌─────────────┐
│ Users Page  │ → useUsers(page, 10) fetches data
└─────────────┘
       ↓
┌─────────────┐
│  useUsers   │ → GET /api/users?page={page}&pageSize=10
│    Hook     │
└─────────────┘
       ↓
┌─────────────┐
│  API Layer  │ → usersApi.getAll(page, pageSize)
└─────────────┘
       ↓
┌─────────────┐
│  Backend    │ → UserService.ListAsync(page, pageSize)
│   API       │
└─────────────┘
```

**Mutation flow**:
```
User action (Add/Edit/Delete)
       ↓
usersApi.create/update/delete
       ↓
API request to backend
       ↓
Success → refetch() → useUsers fetches fresh data
       ↓
Table updates with new data
```

---

### Related Components

🤖 **Components used by this page:**

| Component | Usage | Documented? |
|-----------|-------|-------------|
| `Layout` | Page wrapper with nav/header | ❓ |
| `Card` | Wraps table and error states | ❓ |
| `Table` | Displays user data in rows | ❓ |
| `Button` | Add User, Edit, Delete, Save, Cancel, Pagination | ✅ (see Button_doc.md) |
| `StatusBadge` | Active/Inactive status display | ❓ |

❓ **Consumers of this component:**
- App router (Routes configuration)
- Admin dashboard navigation

---

## Backend Integration

### API Connection Map

🤖 **This component connects to the backend via:**

| UI Layer | → | API Client Layer | → | Backend Endpoint | → | Backend Service | → | Database Table |
|----------|---|------------------|---|------------------|---|-----------------|---|----------------|
| 🤖 Users Page | → | `usersApi.getAll()` | → | `GET /api/users` | → | `UserService.ListAsync()` | → | `training.Users` |
| 🤖 Users Page (Create) | → | `usersApi.create()` | → | `POST /api/users` | → | `UserService.CreateAsync()` | → | `training.Users` |
| 🤖 Users Page (Edit) | → | `usersApi.update()` | → | `PUT /api/users/{id}` | → | `UserService.UpdateAsync()` | → | `training.Users` |
| 🤖 Users Page (Delete) | → | `usersApi.delete()` | → | `DELETE /api/users/{id}` | → | `UserService.DeleteAsync()` | → | `training.Users` |

**Related Documentation**:
- **API Endpoints**: See [UsersController API Documentation](../../../backend/docs/api/UsersController_api.md) for detailed endpoint specifications
- **Business Logic**: See [UserService Documentation](../../../backend/docs/services/UserService_doc.md) for service layer logic and business rules
- **Database Schema**: See [Users Table Documentation](../../../POC_SpecKitProj/docs/tables/Users_doc.md) for table structure and constraints

❓ **Integration notes**:
- Authentication: JWT tokens required? How is authentication handled in API calls?
- Rate limiting: Are there rate limits on user endpoints?
- Caching: Should we cache user list data? For how long?
- Offline behavior: What happens when network is unavailable? Mock data enabled for development.

---

## API Integration

### Endpoints Used

🤖 **API endpoints called:**

| Endpoint | Method | When Called | Purpose |
|----------|--------|-------------|---------|
| `/api/users` | GET | Page load, pagination, after mutations | Fetch paginated user list |
| `/api/users` | POST | Form submit (create mode) | Create new user |
| `/api/users/{id}` | PUT | Form submit (edit mode) | Update existing user |
| `/api/users/{id}` | DELETE | Delete button → confirm → delete | Remove user account |

### Request/Response Types

🤖 **TypeScript interfaces:**

```typescript
// Request types
interface CreateUserRequest {
  email: string;
  fullName: string;
  isActive: boolean;
}

interface UpdateUserRequest {
  email: string;
  fullName: string;
  isActive: boolean;
}

// Response types
interface UserSummary {
  id: string;
  email: string;
  fullName: string;
  isActive: boolean;
  createdUtc: string;
}

interface PagedUsers {
  items: UserSummary[];
  page: number;
  pageSize: number;
  totalCount: number;
  totalPages: number;
}
```

### Error Handling

🤖 **Error handling strategy:**

**API errors**:
- Caught in try-catch blocks
- Displayed in:
  - Page-level error: Red error message in Card (fetch errors)
  - Form-level error: Red banner in modal (create/update errors)
  - Delete errors: Browser alert dialog

**Error message extraction**:
```typescript
err.response?.data?.message || err.message
```

❓ **Error handling gaps**:
- No retry mechanism for failed requests
- No offline detection
- No error logging/analytics
- Delete errors shown in alert (should use toast/notification)
- No validation error field highlighting

---

## Performance Considerations

❓ **Performance analysis:**

### Optimizations Used

🤖 **Current optimizations:**
- `useMemo` for table data transformation (prevents re-computation on every render)
- `useMemo` for columns definition (prevents recreation on every render)
- Pagination limits data size (10 users per page)
- Controlled re-fetching (only on explicit triggers: page change, mutations)

### Performance Concerns

❓ **Potential issues:**
- **Table re-renders**: Columns include inline arrow functions (`onClick` handlers) which create new function references on every render → potential performance hit with large tables
- **No debouncing**: No search/filter functionality yet, but should add debouncing if implemented
- **No virtual scrolling**: Fine for 10 items/page, but would be needed for larger page sizes
- **Full re-fetch after mutations**: Could use optimistic UI updates instead
- **No caching**: useUsers refetches on every mount (could cache with React Query)

### Recommendations

- Extract table row action handlers to `useCallback`
- Implement React Query for caching and background refetches
- Add loading skeletons instead of "Loading users..." text
- Consider optimistic UI updates for better perceived performance

---

## Testing

### Test Coverage

❓ **Testing status:**

**Unit tests**: ❌ Not found  
**Integration tests**: ❌ Not found  
**E2E tests**: ❌ Not found

**Recommended test cases**:

```typescript
describe('Users Page', () => {
  it('renders loading state initially', () => {
    // Mock useUsers to return loading=true
    // Assert "Loading users..." is visible
  });

  it('renders user table when data loads', () => {
    // Mock useUsers to return mock data
    // Assert table renders with correct rows
  });

  it('opens create modal when Add User clicked', () => {
    // Click "Add User" button
    // Assert modal is visible
    // Assert form is empty
  });

  it('opens edit modal with pre-filled data when Edit clicked', () => {
    // Click "Edit" on a specific row
    // Assert modal is visible
    // Assert form is pre-filled with user data
  });

  it('creates new user on form submit', async () => {
    // Open create modal
    // Fill form with valid data
    // Submit form
    // Assert usersApi.create was called
    // Assert modal closes
    // Assert refetch was triggered
  });

  it('shows error banner on create failure', async () => {
    // Open create modal
    // Mock API to return 409 Conflict
    // Submit form
    // Assert error banner is visible
    // Assert modal stays open
  });

  it('deletes user after confirmation', async () => {
    // Mock window.confirm to return true
    // Click "Delete" button
    // Assert usersApi.delete was called
    // Assert refetch was triggered
  });

  it('cancels delete when user clicks Cancel', async () => {
    // Mock window.confirm to return false
    // Click "Delete" button
    // Assert usersApi.delete was NOT called
  });

  it('handles pagination correctly', () => {
    // Mock data with multiple pages
    // Click "Next" button
    // Assert page state updates
    // Assert useUsers called with page=2
  });

  it('disables Previous button on first page', () => {
    // Mock data with page=1
    // Assert "Previous" button is disabled
  });

  it('disables Next button on last page', () => {
    // Mock data with page=totalPages
    // Assert "Next" button is disabled
  });
});
```

---

## Known Issues & Limitations

❓ **Current limitations:**

### Technical Debt

- ❌ **No CSS module**: All styles are inline, reducing maintainability
- ❌ **Hard-coded page size**: Cannot change 10 items per page without code change
- ❌ **Browser confirm dialog**: Delete confirmation uses native `confirm()` - should use custom modal
- ❌ **Browser alert for errors**: Delete errors use native `alert()` - should use toast/notification
- ❌ **No search/filter**: Cannot search users by email or name
- ❌ **No sort**: Cannot sort table columns
- ❌ **No bulk actions**: Cannot select multiple users for bulk operations
- ❌ **No export**: Cannot export user list to CSV/Excel

### Accessibility Gaps

- ❌ Modal lacks proper ARIA attributes and focus management
- ❌ No Escape key handler to close modal
- ❌ No focus trap in modal
- ❌ Missing ARIA live regions for dynamic content updates
- ❌ Error announcements not accessible to screen readers

### UX Issues

- ❌ No loading indicator in modal during form submission
- ❌ No success feedback after create/update (just closes modal)
- ❌ Delete confirmation text is generic (should show impact, e.g., "This will also remove X enrollments")
- ❌ No undo for delete action
- ❌ Form validation happens only on submit (no real-time validation)
- ❌ No dirty form warning when closing modal with unsaved changes

### Performance

- ❌ Inline function creation in table cells on every render
- ❌ No memoization of row components
- ❌ Full refetch after mutations (no optimistic updates)

---

## Future Enhancements

❓ **Planned improvements:**

### High Priority
- [ ] Add search/filter by email or name
- [ ] Replace browser confirm/alert with custom components
- [ ] Add loading states in modal during form submission
- [ ] Implement proper modal accessibility (ARIA, focus trap, Escape key)
- [ ] Add success notifications/toasts

### Medium Priority
- [ ] Add table sorting by columns
- [ ] Add user role/permission display (if applicable)
- [ ] Add bulk selection and bulk actions
- [ ] Add export to CSV functionality
- [ ] Implement real-time form validation

### Low Priority
- [ ] Add advanced filters (by status, date range, etc.)
- [ ] Add user profile preview on hover
- [ ] Add keyboard shortcuts (Ctrl+N for new user, etc.)
- [ ] Add column visibility toggles
- [ ] Add customizable page size

---

## Documentation Standards

### This template follows the Application Knowledge Repo (AKR) system

**For universal conventions, see**:
- [AKR_CHARTER.md](../../../charters/AKR_CHARTER.md) - Core principles, generic data types, feature tags, Git format

**For UI-specific conventions, see**:
- [AKR_CHARTER_UI.md](../../../charters/AKR_CHARTER_UI.md) - UI component documentation standards (if exists)

**For step-by-step documentation process, see**:
- [UI_Component_Documentation_Developer_Guide.md](../guides/UI_Component_Documentation_Developer_Guide.md) - How to use this template with Copilot/AI

**For tagging strategy, see**:
- [TAGGING_STRATEGY_TAXONOMY.md](../../../AKR_files/TAGGING_STRATEGY_TAXONOMY.md) - Complete tag reference
- [TAGGING_STRATEGY_OVERVIEW.md](../../../AKR_files/TAGGING_STRATEGY_OVERVIEW.md) - Tagging system overview

---

## Related Documentation

- **Service Layer**: [UserService Documentation](../../../backend/docs/services/UserService_doc.md)
- **API Layer**: [UsersController API Documentation](../../../backend/docs/api/UsersController_api.md)
- **Database Layer**: [Users Table Documentation](../../../POC_SpecKitProj/docs/tables/Users_doc.md)
- **UI Components**:
  - [Button Component](./Button_doc.md)
  - Table Component (pending)
  - Card Component (pending)
  - StatusBadge Component (pending)
- **Custom Hooks**:
  - useUsers Hook (pending)

---

## Change History

**Component evolution is tracked in Git**, not in this document.

To see how this component evolved:
```bash
git log training-tracker-ui/src/pages/Users.tsx
git log -p training-tracker-ui/src/pages/Users.tsx
```

**Include feature tags in commit messages**:
```bash
git commit -m "feat: add search to Users page (FN#####_US#####) #user-management #search"
```

---

## AI Generation Instructions

🤖
- All content above marked 🤖 is generated from component code and conventions.
- ❓ sections require human input for business context, rationale, and UX decisions.

**AI-generated tags rationale**:
- `#user-management` - Primary feature domain (CRUD for users)
- `#user-profile` - Related to user profile data
- `#ui-component` - Component type classifier
- `#page` - Page-level component (full route)
- `#table` - Uses table component for data display
- `#form` - Contains create/edit forms
- `#modal` - Uses modal for forms
- `#core-feature` - Critical admin functionality

---

## Template Metadata

**Template Version**: 1.0 (UI Component)  
**Last Updated**: 2025-11-12  
**Maintained By**: Frontend Team  
**Part of**: Application Knowledge Repo (AKR) system

**Related Files**:
- [UI_Component_Documentation_Developer_Guide.md](../guides/UI_Component_Documentation_Developer_Guide.md)
- [AKR_CHARTER.md](../../../charters/AKR_CHARTER.md)
- [TAGGING_STRATEGY_TAXONOMY.md](../../../AKR_files/TAGGING_STRATEGY_TAXONOMY.md)
