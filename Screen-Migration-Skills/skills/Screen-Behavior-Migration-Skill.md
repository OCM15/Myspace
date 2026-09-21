# Screen Behavior Migration Skill

## Purpose

Verify that user operations behave equivalently after migration.

## Behavior Scope

### Initial Display

- Initial values
- DB-loaded values
- Previous-screen values
- User/session-dependent values

### Input

- Editability
- Focus
- Input restrictions
- Validation timing

### Button / Link

For each action verify:

1. Click
2. Validation
3. Confirmation
4. Request
5. Success behavior
6. Error behavior
7. Navigation
8. State preservation

### Navigation

- Forward
- Back
- Cancel
- Refresh
- Direct URL access
- Redirect
- Session timeout

### Duplicate Operations

- Double click
- Double submit
- Browser refresh after submit
- Back then submit again

### Permission / Display

- User group
- Role
- Transaction type
- Record state
- Other conditional rules

## Rule

A visually equivalent screen is not behaviorally equivalent unless the user operations and resulting states are equivalent.
