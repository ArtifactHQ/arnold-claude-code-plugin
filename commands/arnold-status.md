---
name: arnold:status
description: Show current pipeline status — what's defined, what's built, and what's pending.
---

# /arnold:status

Get a quick overview of the current project state by pulling data from Arnold.

## Steps

1. Call `describe_product` to get the current product description and spec summary.
2. Call `get_tasks` to retrieve all tasks and their statuses.
3. Present a summary based on the project's current phase:

### If tasks exist (execution phase)

**Product:** One-line description of what's being built.

**Spec Status:** Whether a spec exists, how many requirements are defined, last revision date.

**Tasks:**
- Total tasks and how they break down by status (pending, in-progress, completed, failed)
- Current tier being worked on
- Next actionable item

**Issues:** Any open issues or blockers reported via `report_issue`.

### If no tasks exist (discovery phase)

The product has a spec but hasn't moved to execution yet. Present:

**Product:** One-line description of what's being built.

**Spec Status:** Number of personas, domains, and capabilities defined. Number of spec revisions.

**Discovery:** Suggest next steps — the user can continue exploring personas and capabilities, refine the spec with changes, or start building. Do not say "nothing to build" — the product is in the discovery phase.

### General

Keep the output concise. The user wants a glance, not a deep dive. If they want details on a specific area, they will ask.
