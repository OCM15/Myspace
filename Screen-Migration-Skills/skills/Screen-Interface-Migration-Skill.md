# Screen Interface Migration Skill

## Purpose

Preserve all interfaces surrounding a migrated screen.

## Interface Scope

### Screen-to-Screen

Check:

- URL parameters
- request parameters
- hidden fields
- session attributes
- redirect attributes
- navigation state

### Screen-to-API

Check:

- request field
- response field
- field name
- type
- length
- nullable
- required
- default
- format
- conversion
- direction

### DTO / Form / Command

Check:

- field coverage
- type mapping
- annotation/validation mapping
- serialization/deserialization
- enum mapping
- date mapping
- numeric mapping
- null behavior

### API / Service / Repository

Check only the contract relevant to preserving the screen function.

## High-Risk Data Semantics

Explicitly verify:

- NULL vs empty
- blank vs whitespace
- date format
- timezone where relevant
- decimal scale
- rounding
- negative values
- enum/code values
- full-width/half-width
- character encoding

## Rule

A field that is absent from the new interface is a migration defect unless it is explicitly mapped, merged, replaced, or documented obsolete.
