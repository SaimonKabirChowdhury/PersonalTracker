---
name: clean-code-readability
description: Enforce clean code and maintain high readability in code changes while prioritizing existing project libraries. Use when writing, refactoring, reviewing, or modifying code, and when deciding whether to add dependencies.
---

# Clean Code Readability

## Core Rules

1. Write clean, readable, and maintainable code.
2. Prioritize existing project libraries before considering new dependencies.
3. Only suggest adding a new library when the requirement cannot be reasonably solved with the current stack.
4. Keep naming clear and intention-revealing.
5. Prefer simple solutions over clever or complex ones.

## Dependency Decision Policy

When a task could involve a new dependency, follow this order:

1. Check whether the project already has a library or utility that can solve the problem.
2. If an existing library can solve it with acceptable complexity, use that library.
3. If no existing library can solve it well, explain why and propose one minimal new dependency.
4. Do not propose multiple alternatives unless the user explicitly asks for options.

## Implementation Guidelines

- Keep functions focused and small when practical.
- Avoid unnecessary abstractions and duplicate logic.
- Preserve existing architecture and conventions.
- Add comments only for non-obvious reasoning.
- Keep error handling explicit and readable.

## Communication Style

When presenting changes:

- Briefly explain how readability improved.
- Call out which existing library was reused.
- If a new dependency is necessary, clearly justify why existing libraries were insufficient.

## Quick Checklist

Before finalizing work, verify:

- [ ] Code is easy to read and understand.
- [ ] Existing libraries were used first.
- [ ] No unnecessary dependency was introduced.
- [ ] Naming and structure are consistent with the codebase.
- [ ] Complexity is minimized.
