# Screen Inventory Skill

## Purpose

Create a complete functional inventory of a legacy screen before migration.

## Inventory Scope

### Visible UI

- Text field
- Text area
- Select
- Radio
- Checkbox
- Table
- Table column
- Label
- Link
- Button
- Tab
- Pagination
- Popup

### Non-Visible Data

- Hidden fields
- Request parameters
- URL parameters
- Session attributes
- Cookies
- Browser storage
- CSRF/token fields where applicable

### Functional Rules

- Required/optional
- Data type
- Length
- Range
- Format
- Default value
- Initial value
- Display condition
- Editability
- Permission
- Error message
- Navigation
- API call
- Screen-to-screen parameter

## Rules

1. Inventory implementation and behavior, not just visible HTML.
2. Do not assume a hidden field is unused.
3. Do not delete an item because it is not visible in the default state.
4. Record conditional visibility explicitly.
5. Record evidence/source for important rules.

## Output

Create `OldScreenInventory.md` using the provided template.
