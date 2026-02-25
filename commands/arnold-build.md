---
name: arnold:build
description: Start or continue building the project tier-by-tier using Arnold's task plan.
---

# /arnold:build

Begin executing the current project. This pulls the spec and tasks from Arnold and works through them tier-by-tier.

## Steps

1. Call `detect_drift` to check if the codebase has diverged from the spec since the last session. If drift is found, present it and ask the user whether to resolve it first or proceed.

2. Call `get_spec` to retrieve the current specification. Confirm with the user that the spec looks correct before proceeding.

3. Call `get_tasks` to get the full task list. Identify the lowest incomplete tier.

4. For the current tier, execute each task in dependency order:
   a. `start_task` — mark the task as in-progress and read its full description
   b. Implement the task — write code, run commands, create files as needed
   c. `complete_task` — mark the task as done with a result summary

5. After all tasks in the tier are complete, call `validate_tier` to run quality checks.

6. If validation passes, report the tier summary and move to the next tier (repeat from step 4).

7. If validation fails, review the failures:
   - Fix addressable issues and re-validate
   - Call `report_issue` for problems that need user input
   - Do not proceed to the next tier until validation passes

## Behavior

- Work through one tier at a time. Never skip ahead.
- After each tier, give the user a brief summary: what was built, what passed validation, what's next.
- If a task seems wrong or contradicts the spec, stop and ask rather than implementing something incorrect.
- If this is the first run and no tasks exist yet, tell the user they need to design their product first (suggest /arnold:status or just describing what they want to build).
