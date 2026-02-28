# Arnold Claude Code Plugin

A Claude Code plugin that connects your AI coding assistant to Arnold Pipeline. Design your product through conversation, build it tier-by-tier with quality gates, and detect drift between your spec and codebase.

Arnold maintains a living specification for your project. This plugin gives Claude Code access to Arnold's tools so it can help you discover, design, plan, build, and validate your product without leaving your editor.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and configured
- Arnold Pipeline installed:
  ```sh
  brew tap ArtifactHQ/arnold
  brew install arnold
  ```
  Or via RubyGems:
  ```sh
  gem install arnold_pipeline
  ```
- The `arnold` command must be on your PATH

## Installation

Add the marketplace, then install the plugin:

```sh
claude plugin marketplace add ArtifactHQ/arnold-claude-code-plugin
claude plugin install arnold
```

## Getting Started

Start by describing what you want to build. Arnold generates an initial spec, then you explore and refine it through conversation before writing any code.

1. **Describe your idea:** "I want to build a dog walking app"
2. **Explore what Arnold created:** ask about personas, domains, features
3. **Refine with changes:** "walkers should be able to set their own prices"
4. **Think out loud:** "what if we added group walks?"
5. **When ready:** "let's build this"

You can use `/arnold:new` for an explicit starting point, or just describe your idea in chat.

## Commands

### /arnold:new

Start a new product. Describe your idea and Arnold generates an initial spec with personas, domains, and capabilities. Then explore and refine through conversation.

```
/arnold:new a dog walking app
/arnold:new
```

### /arnold:status

Quick overview of your project state. During discovery, shows the spec outline and suggests exploration. During execution, shows task progress and what's next.

### /arnold:build

Start or continue building your project. Pulls the spec and tasks from Arnold, works through them tier-by-tier, and runs validation after each tier. If the spec hasn't been explored yet, suggests reviewing it first.

### /arnold:drift

Check for divergence between your specification and codebase. Presents findings in plain language and helps you resolve them.

Accepts an optional domain scope:
```
/arnold:drift auth
/arnold:drift database
```

## How It Works

The plugin launches `arnold mcp` as a subprocess communicating over the MCP (Model Context Protocol) stdio transport. Claude Code sends tool calls to Arnold, which manages the pipeline state, spec revisions, task planning, and validation.

No data leaves your machine beyond what Claude Code already sends. Arnold runs locally and stores pipeline data in `~/.arnold_pipeline/`.

## MCP Tools

The plugin exposes Arnold's tools to Claude Code, organized into five tracks:

### Discovery Track
| Tool | Description |
|------|-------------|
| `create_product` | Start a pipeline from a natural language product idea |
| `explore_persona` | Drill into a persona's experience, goals, and workflows |
| `explore_capability` | Drill into a specific capability — behavior, edge cases, constraints |
| `what_if` | Explore a hypothetical scenario without committing to it |
| `get_history` | Review how the spec has evolved over the conversation |

### Product Track
| Tool | Description |
|------|-------------|
| `describe_product` | Capture or update the product description from natural language |
| `explore_domain` | Investigate domain entities, relationships, and patterns |
| `propose_change` | Draft a spec change and preview its impact |
| `confirm_change` | Commit a previously proposed spec change |

### Engineering Track
| Tool | Description |
|------|-------------|
| `ask_engineer` | Get engineering analysis in the context of the current spec |
| `explore_architecture` | Examine architecture decisions and tech stack choices |
| `explain_recipe` | Describe what a recipe template provides |

### Execution Track
| Tool | Description |
|------|-------------|
| `get_spec` | Retrieve the current specification |
| `get_tasks` | List tasks, optionally filtered by tier or status |
| `start_task` | Mark a task as in-progress |
| `complete_task` | Mark a task as done with a result summary |
| `report_issue` | Flag a problem during execution |
| `validate_tier` | Run quality validation after completing a tier |

### Maintenance Track
| Tool | Description |
|------|-------------|
| `detect_drift` | Scan for spec-to-code divergence |
| `resolve_drift` | Address a drift item by updating spec or code |

## Version Compatibility

| Plugin Version | Min Arnold Version |
|---------------|-------------------|
| 0.2.0 | 0.2.0 |
| 0.1.0 | 0.1.0 |

## License

MIT
