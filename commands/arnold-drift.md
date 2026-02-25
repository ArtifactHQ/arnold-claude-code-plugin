---
name: arnold:drift
description: Check for drift between the specification and the current codebase.
args: "[domain] — optional domain to scope the drift check (e.g., 'auth', 'api', 'database')"
---

# /arnold:drift

Run drift detection to find where the codebase has diverged from the spec.

## Steps

1. Call `detect_drift` to scan for differences between the spec and the codebase. If the user provided a domain argument, pass it to scope the check.

2. Organize the findings into categories:
   - **Spec says, code doesn't:** Features or behaviors defined in the spec but missing or incomplete in code.
   - **Code does, spec doesn't:** Implementation details present in code that aren't captured in the spec.
   - **Contradictions:** Places where code actively contradicts the spec.

3. For each drift item, present it in plain language:
   - What the spec says
   - What the code does (or doesn't do)
   - Suggested resolution: update the spec, update the code, or flag for discussion

4. Ask the user how they want to handle the findings. For each item they want to resolve, call `resolve_drift` with their chosen direction (update spec or update code).

## Behavior

- Present drift at the product level, not as raw diffs. "The spec requires email verification on signup, but the code skips it" is better than "auth_controller.rb line 42 missing verification call."
- If no drift is found, say so clearly and suggest next steps.
- Group related drift items together. If three endpoints are all missing auth checks, that's one finding, not three.
