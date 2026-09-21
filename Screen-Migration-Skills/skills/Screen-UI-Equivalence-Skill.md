# Screen UI Equivalence Skill

## Purpose

Verify that every legacy screen function has an equivalent representation in the new screen.

## Comparison Dimensions

- Field presence
- Field meaning
- Label meaning
- Editability
- Read-only state
- Table columns
- Button/link presence
- Control type
- Display condition
- Initial value
- Hidden data

## Status Definitions

- `MATCH`: equivalent
- `CONDITIONAL`: equivalent under a documented condition
- `RENAMED`: name changed but meaning preserved
- `REPLACED`: UI implementation changed but function preserved
- `MERGED`: multiple old items represented by one new item
- `SPLIT`: one old item represented by multiple new items
- `OBSOLETE`: intentionally removed with evidence
- `MISSING`: no equivalent found
- `UNKNOWN`: cannot determine

## Rules

- Never treat `UNKNOWN` as `MATCH`.
- Never treat `MISSING` as `OBSOLETE`.
- Every `OBSOLETE` item requires documented evidence.
- MERGED/SPLIT items require mapping details.
- Compare function, not visual appearance alone.

## Output

Create and maintain `ScreenTraceabilityMatrix.md`.
