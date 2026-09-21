# Screen Validation Skill

## Purpose

Preserve input validation semantics during screen migration.

## Required Validation Attributes

For every input item, compare:

- Required
- Data type
- Minimum length
- Maximum length
- Minimum value
- Maximum value
- Allowed characters
- Format
- Decimal scale
- Rounding
- NULL handling
- Empty string handling
- Blank/whitespace handling
- Trim behavior
- Default value
- Cross-field validation
- Error message
- Error location
- Validation timing

## Boundary Tests

Where applicable, test:

- null
- empty
- blank
- minimum
- minimum - 1
- maximum
- maximum + 1
- zero
- negative
- invalid format
- special characters
- full-width / half-width
- Japanese characters
- excessive length

## Important Semantic Rule

`null`, `""`, `" "`, and trimmed values must not be assumed equivalent.

## Output

Record validation differences in the Traceability Matrix and test cases.
