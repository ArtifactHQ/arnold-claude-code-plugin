# Arnold Claude Code Plugin

A Claude Code plugin that connects your AI coding assistant to Arnold Pipeline. Design your product through conversation, build it tier-by-tier with quality gates, and detect drift between your spec and codebase.

Arnold maintains a living specification for your project. This plugin gives Claude Code access to Arnold's tools so it can help you design, plan, build, and validate your product without leaving your editor.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and configured
- Arnold Pipeline installed:
  ```sh
  brew install arnold
  ```
  Or via RubyGems:
  ```sh
  gem install arnold_pipeline
  ```
- The `arnold` command must be on your PATH

## Installation

Using the Claude Code CLI:

```sh
claude plugin add arnold
```

Or manually clone and link:

```sh
git clone https://github.com/ArtifactHQ/arnold-claude-code-plugin.git
claude plugin add ./arnold-claude-code-plugin
```

## Commands

### /arnold:status

Quick overview of your project state: what's defined in the spec, how tasks are progressing, and what's next.

### /arnold:build

Start or continue building your project. Pulls the spec and tasks from Arnold, works through them tier-by-tier, and runs validation after each tier.

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

The plugin exposes Arnold's tools to Claude Code, organized into four tracks:

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

### Drift Track
| Tool | Description |
|------|-------------|
| `detect_drift` | Scan for spec-to-code divergence |
| `resolve_drift` | Address a drift item by updating spec or code |

## Version Compatibility

| Plugin Version | Min Arnold Version |
|---------------|-------------------|
| 0.1.0 | 0.1.0 |

## License

MIT
